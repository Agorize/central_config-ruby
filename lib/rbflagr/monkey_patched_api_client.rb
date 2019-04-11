# frozen_string_literal: true

require 'rbflagr/api_client'

module Flagr
  class MonkeyPatchedApiClient < ApiClient
    def build_request(*)
      @default_headers.merge!(CentralConfig.config.flagr_headers)
      super
    end
  end

  class ApiClient
    def self.default
      @@default ||= MonkeyPatchedApiClient.new
    end
  end
end
