# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module CentralConfig
  class Config
    def initialize(data = {}, adapter: CentralConfig::Adapters::Flagr.new)
      @adapter = adapter
      @data = data
    end

    def flag?(flag_name, default: false)
      variant = data.dig(:"flag_#{flag_name}", :variant)

      return variant == 'on' if variant.present?

      block_given? ? yield : default
    end

    def load(entity_id:, context:, flags:)
      self.data = adapter.call(entity_id: entity_id, context: context, flags: flags)
    rescue StandardError => e
      warn "Returning empty central config due to #{e.inspect}"
      self.data = {}
    end

    def setting(setting_name, *dig_path, default: nil)
      value = data.dig(:"setting_#{setting_name}", :attachment, *dig_path)

      return value unless value.nil?

      block_given? ? yield : default
    end

    private

    attr_accessor :data
    attr_reader :adapter
  end
end
