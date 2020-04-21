module Integreat
  class Installation < ApplicationRecord
    belongs_to :app
    has_secure_token :secret
  end
end
