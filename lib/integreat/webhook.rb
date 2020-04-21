module Integreat
  class Webhook

    def payload
      raise "Please define a `payload` method in your hook or pass it as an argument to `send`"
    end

    def account_id
      raise "You need to define `account_id` in your hook or pass it as an argument to `send`"
    end

    def event_name
      self.class.to_s.demodulize.underscore.gsub(/_hook$/,"")
    end

    def object_class
      event_name.camelize.constantize
    end

    def object
      object_class.find(@object_id)
    end

    def initialize(account_id:, object_id:)
      @account_id = account_id
      @object_id = object_id
    end

    def send(action, **args)
      local_payload = args.fetch(:payload) { payload }
      local_account_id = args.fetch(:account_id) { account_id }

      RailsDemux::Sidekiq.new.send_to_apps(
        self.class,
        String(action),
        @object_id,
        context,
        local_account_id
      )

      ResolveEventToAppsJob.perform_async(
        account_id: local_account_id,
        payload: { event: event_name, action: String(action) }.merge(local_payload)
      )
    end
  end

  class Demux::Signal
    def self.attributes(attr)
      @object_class = attr.fetch(:object_class)
      @name = attr.fetch(:name)
    end

    def self.object_class
      @object_class
    end

    def self.name
      @name
    end

    def name
      self.class.name
    end

    def initialize(object_id, **args)
      @object_id = object_id
      @args = args
    end

    def object
      self.class.object_class.find(@object_id)
    end

    def account_id
      @args.fetch(:account_id) { fetch_account_id }
    end

    def send(action)
      RailsDemux::Sidekiq.new.send_to_apps(
        self.class,
        String(action),
        @object_id,
        @args
      )
    end
  end

  # LessonPublicitySignal.new(lesson.id).updated
  #
  # LessonPublicitySignal.new(id).body
  # #payload
  # #name
  # #account_id
  class LessonPublicitySignal < Demux::Signal
    attributes object_class: Lesson, name: "lesson_publicity"

    def payload
      {
        company_id: lesson.company_id,
        lesson: {
          id: @object_id,
          name: lesson.name,
          public: lesson.public
        }
      }
    end

    def updated
      send :updated
    end

    def account_id
      object.company_id
    end

    private

    def lesson
      object
    end
  end

  class LessonHook < Integreat::Webhook
    def initialize(actor:,lesson:)
      super(object_id: lesson_id)
      @actor = actor
      @lesson = lesson
    end

    def account_id
      @actor.company_id
    end

    def payload
      lesson_body
    end

    def lesson_body
      {
        lesson: {
          id: @lesson.id,
          name: @lesson.name,
          public: @lesson.public
        },
        company_id: @actor.company_id,
        actor: {
          name: @actor.name
        }
      }
    end

    def updated
      send :updated, account_id: @actor.company_id
    end

    def published
      send :published
    end

    def created
      send :created, account_id: @actor.company_id, payload: lesson_body
    end

    def public(context={})
      send :public, account_id: @actor.company_id, payload: {
        foobar: context[:baz]
      }.merge(lesson_body)
    end
  end
end
