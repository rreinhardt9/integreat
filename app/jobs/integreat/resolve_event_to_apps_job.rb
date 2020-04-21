module Integreat
  class ResolveEventToAppsJob < ApplicationJob
    queue_as :integreat

    def perform(account_id:, payload:)
      installations = Integreat::Installation
        .where(account_id: account_id)
        .where("'lesson' = ANY (authorized_webhook_events)")

      apps = Integreat::App
        .joins(:installations)
        .merge(installations)

      apps.each do |app|
        # sign payload
        post app.webhook_url, signed_payload
      end
    end
  end
end
