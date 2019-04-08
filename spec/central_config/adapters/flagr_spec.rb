# frozen_string_literal: true

RSpec.describe CentralConfig::Adapters::Flagr, :stub_flagr do
  subject { described_class.new(config: config) }

  let(:config) { instance_double(CentralConfig::Config, flagr_host: 'flagr.test.com') }

  describe '.new' do
    it 'expects a :config argument' do
      expect { described_class.new }
        .to raise_exception(ArgumentError, 'missing keyword: config')
    end
  end

  describe '#call' do
    it 'expects an :entity_id argument' do
      expect { subject.call(config: nil, context: nil) }
        .to raise_exception(ArgumentError, 'missing keyword: entity_id')
    end

    it 'expects a :context argument' do
      expect { subject.call(config: nil, entity_id: nil) }
        .to raise_exception(ArgumentError, 'missing keyword: context')
    end

    it 'calls the Flagr API and extracts the information' do
      data = subject.call(
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

    context 'when flags are provided' do
      let(:data) do
        subject.call(
          entity_id: '1',
          context: { 'key' => 'value' },
          flags: %w[flag_test setting_test])
      end

      it 'calls them in the batch evaluation' do
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

    context 'when no flags are provided' do
      let(:data) { subject.call(entity_id: '1', context: { 'key' => 'value' }) }

      it 'calls the batch evaluation on all enabled flags' do
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
end
