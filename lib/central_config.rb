# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

require 'central_config/version'
require 'central_config/engine' if defined?(Rails)

# FIXME: Waiting for a solution to https://github.com/checkr/rbflagr/issues/6
require 'rbflagr/monkey_patched_api_client'

module CentralConfig
  autoload :Adapters, 'central_config/adapters'
  autoload :Config, 'central_config/config'

  module Base
    delegate :flag?, :load, :setting, to: :config

    @@configure_block = proc {}

    def config
      Thread.current[:central_config] ||= begin
        conf = CentralConfig::Config.new
        @@configure_block.call(conf)
        conf
      end
    end

    def config=(value)
      Thread.current[:central_config] = value
    end

    def configure(&block)
      @@configure_block = block
    end
  end

  extend Base
end
