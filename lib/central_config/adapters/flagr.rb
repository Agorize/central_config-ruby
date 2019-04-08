# frozen_string_literal: true

require 'json'
require 'rbflagr'

module CentralConfig
  module Adapters
    class Flagr
      def initialize(config:)
        ::Flagr.configure do |flagr|
          flagr.host = config.flagr_host.to_s

          # FIXME: This is ignored by the lib
          # flagr.api_key['api_key'] = ENV['CENTRAL_CONFIG_TOKEN']
        end

        @evaluation_api = ::Flagr::EvaluationApi.new
        @flag_api = ::Flagr::FlagApi.new
      end

      def call(entity_id:, context:, flags: enabled_flags)
        flags = evaluate_flags(entity_id, context, flags)

        flags.each_with_object({}) do |flag, data|
          flag_key = flag[:flagKey]

          next if flag_key.blank?

          data[flag_key.to_sym] = {
            attachment: flag[:variantAttachment],
            variant: flag[:variantKey]
          }
        end
      end

      private

      def enabled_flags
        flag_api.find_flags(enabled: true).map(&:key)
      end

      def evaluate_flags(entity_id, context, flags)
        body = ::Flagr::EvaluationBatchRequest.new(
          entities: [{
            entity_id: entity_id,
            entity_context: context
          }],
          flagKeys: flags)

        response = evaluation_api.post_evaluation_batch(body)
        response.to_body.fetch(:evaluationResults)
      end

      attr_reader :config, :evaluation_api, :flag_api
    end
  end
end
