module Integreat
  class App < ApplicationRecord
    has_many :installations
    has_secure_token :secret
  end
end
