# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each, :stub_flagr do |example|
    scenario = example.metadata[:stub_flagr]
    scenario = :all if scenario.is_a?(TrueClass)

    scenario_path = "#{__dir__}/../flag_scenarios/flagr/#{scenario}"

    flags_payload = File.read("#{scenario_path}/flags.json")
    eval_payload = File.read("#{scenario_path}/eval.json")
    headers = { 'content-type': 'application/json' }

    stub_request(:get, 'http://flagr.test.com/api/v1/flags?enabled=true')
      .to_return(body: flags_payload, headers: headers)

    stub_request(:post, 'http://flagr.test.com/api/v1/evaluation/batch')
      .to_return(body: eval_payload, headers: headers)
  end
end
