# frozen_string_literal: true

require 'json'
require 'rbflagr'

module CentralConfig
  module Adapters
    class Flagr
      def call(entity_id:, context:, flags:)
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

      def evaluation_api
        ::Flagr.configure do |config|
          config.host = ENV['CENTRAL_CONFIG_HOST']

          # FIXME: This is ignored by the lib
          # config.api_key['api_key'] = ENV['CENTRAL_CONFIG_TOKEN']
        end

        ::Flagr::EvaluationApi.new
      end
    end
  end
end
