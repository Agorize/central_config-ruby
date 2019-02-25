# frozen_string_literal: true

RSpec.configure do |config|
  config.after { CentralConfig.config = nil }
end
