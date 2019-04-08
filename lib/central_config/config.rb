# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module CentralConfig
  class Config
    attr_accessor :adapter, :error_handler, :flagr_host

    def initialize(data = {}, adapter: nil)
      @data = data
      @error_handler = method(:error_warning)
      @flagr_host = ENV['CENTRAL_CONFIG_FLAGR_HOST']

      @adapter = adapter || default_adapter
    end

    def flag?(flag_name, default: false)
      variant = data.dig(:"flag_#{flag_name}", :variant)

      return variant == 'on' if variant.present?

      block_given? ? yield(flag_name) : default
    end

    def load(entity_id:, context:)
      self.data = adapter.call(entity_id: entity_id, context: context)
    rescue StandardError => exception
      error_handler.call(exception)
      self.data = {}
    end

    def setting(setting_name, *dig_path, default: nil)
      value = data.dig(:"setting_#{setting_name}", :attachment, *dig_path)

      return value unless value.nil?

      block_given? ? yield(setting_name, *dig_path) : default
    end

    private

    def default_adapter
      CentralConfig::Adapters::Flagr.new(config: self)
    end

    def error_warning(exception)
      warn "Returning empty central config due to #{exception.inspect}"
    end

    attr_accessor :data
  end
end
