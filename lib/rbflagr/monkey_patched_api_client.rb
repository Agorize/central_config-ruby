# frozen_string_literal: true

require 'rbflagr/api_client'

module Flagr
  class MonkeyPatchedApiClient < ApiClient
    def build_request(*)
      config = CentralConfig.config
      request = super

      request.options[:headers].merge!(config.flagr_headers)

      if config.flagr_basic_auth
        request.options[:userpwd] = config.flagr_basic_auth
      end

      request
    end
  end

  class ApiClient
    def self.default
      @@default ||= MonkeyPatchedApiClient.new
    end
  end
end
