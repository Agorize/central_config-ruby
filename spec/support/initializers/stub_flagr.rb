# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each, :stub_flagr do
    stub_request(:post, 'http://flagr.com/api/v1/evaluation/batch').to_return do |request|
      scenario = JSON.parse(request.body).dig('flagKeys').sort.join('_')

      path = "../../support/flag_scenarios/flagr/#{scenario}.json"
      flagr_body = File.read(File.expand_path(path, __dir__))

      { status: 200, body: flagr_body, headers: {} }
    end
  end
end
