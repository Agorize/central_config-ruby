# frozen_string_literal: true

RSpec.describe CentralConfig::Adapters::Flagr, :stub_flagr do
  describe '#call' do
    let(:config) { instance_double(CentralConfig::Config, flagr_host: 'flagr.com') }

    it 'expects an :entity_id argument' do
      expect { subject.call(config: nil, context: nil, flags: nil) }
        .to raise_exception(ArgumentError, 'missing keyword: entity_id')
    end

    it 'expects an :config argument' do
      expect { subject.call(entity_id: nil, context: nil, flags: nil) }
        .to raise_exception(ArgumentError, 'missing keyword: config')
    end

    it 'expects a :context argument' do
      expect { subject.call(config: nil, entity_id: nil, flags: nil) }
        .to raise_exception(ArgumentError, 'missing keyword: context')
    end

    it 'expects a :flags argument' do
      expect { subject.call(config: nil, entity_id: nil, context: nil) }
        .to raise_exception(ArgumentError, 'missing keyword: flags')
    end

    it 'calls the Flagr API and extracts the information' do
      data = subject.call(
        config: config,
        entity_id: '1',
        context: { 'key' => 'value' },
        flags: %w[flag_test setting_test])

      expect(data).to match(
        flag_test: {
          attachment: {},
          variant: 'on'
        },
        setting_test: {
          attachment: {
            live: false,
            title: 'Agorize'
          },
          variant: 'default'
        })
    end
  end
end
