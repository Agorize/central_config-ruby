# frozen_string_literal: true

require 'active_support/core_ext/module/delegation.rb'

require 'central_config/version'
require 'central_config/engine' if defined?(Rails)

module CentralConfig
  autoload :Adapters, 'central_config/adapters'
  autoload :Config, 'central_config/config'

  module Base
    delegate :flag?, :load, :setting, to: :config

    def config
      Thread.current[:central_config] ||= ::CentralConfig::Config.new
    end

    def config=(value)
      Thread.current[:central_config] = value
    end

    def configure
      yield config
    end
  end

  extend Base
end
