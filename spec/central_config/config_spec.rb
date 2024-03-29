# frozen_string_literal: true

RSpec.describe CentralConfig::Config do
  subject { described_class.new(data, adapter: adapter) }

  let(:adapter) { double }
  let(:data) { {} }

  describe '#adapter' do
    it 'returns the adapter' do
      expect(subject.adapter).to be(adapter)
    end
  end

  describe '#adapter=' do
    it 'sets the adapter' do
      new_adapter = double
      subject.adapter = new_adapter

      expect(subject.adapter).to be new_adapter
    end
  end

  describe '#error_handler=/#error_handler' do
    it 'sets and returns the error_handler' do
      new_error_handler = double
      subject.error_handler = new_error_handler

      expect(subject.error_handler).to be new_error_handler
    end
  end

  describe '#flag?' do
    it 'expects a flag name' do
      error_message = 'wrong number of arguments (given 0, expected 1)'
      expect { subject.flag? }.to raise_error(ArgumentError, error_message)
    end

    context "when the flag is 'on'" do
      let(:data) {{ flag_test: { variant: 'on' } }}

      it 'returns true' do
        expect(subject.flag?(:test)).to be true
      end

      it 'ignores the default value from keyword args' do
        value = subject.flag?(:test, default: 'test')
        expect(value).to be true
      end

      it 'ignores the default value from block' do
        value = subject.flag?(:test) { 'test' }
        expect(value).to be true
      end
    end

    context "when the flag is 'off'" do
      let(:data) {{ flag_test: { variant: 'off' } }}

      it 'returns false' do
        expect(subject.flag?(:test)).to be false
      end

      it 'ignores the default value from keyword args' do
        value = subject.flag?(:test, default: 'test')
        expect(value).to be false
      end

      it 'ignores the default value from block' do
        value = subject.flag?(:test) { 'test' }
        expect(value).to be false
      end
    end

    context 'when the flag is unknown' do
      it 'returns false if no default is provided' do
        expect(subject.flag?(:test)).to be false
      end

      it 'returns the default value if provided by keyword argument' do
        value = subject.flag?(:test, default: 'karg')
        expect(value).to eq 'karg'
      end

      it 'returns the default value if provided by block' do
        value = subject.flag?(:test) { 'block' }
        expect(value).to eq 'block'
      end

      it 'returns the default value from the block if both keyword and block are provided' do
        value = subject.flag?(:test, default: 'karg') { 'block' }
        expect(value).to eq 'block'
      end

      it 'yields the flag name to the provided block' do
        expect { |b| subject.flag?(:unknown, &b) }.to yield_with_args(:unknown)
      end
    end
  end

  describe '#flagr_basic_auth=/#flagr_basic_auth' do
    it 'sets and returns the flagr_basic_auth' do
      new_flagr_basic_auth = double
      subject.flagr_basic_auth = new_flagr_basic_auth

      expect(subject.flagr_basic_auth).to be new_flagr_basic_auth
    end
  end

  describe '#flagr_headers=/#flagr_headers' do
    it 'sets and returns the flagr_headers' do
      new_flagr_headers = { key: :value }
      subject.flagr_headers = new_flagr_headers

      expect(subject.flagr_headers).to eq new_flagr_headers
    end
  end

  describe '#flagr_host=/#flagr_host' do
    it 'sets and returns the flagr_host' do
      new_flagr_host = double
      subject.flagr_host = new_flagr_host

      expect(subject.flagr_host).to be new_flagr_host
    end
  end

  describe '#load' do
    let(:call_args) {{
      entity_id: 'id',
      context: { 'key' => 'value' }
    }}

    let(:settings) {{
      flag_test: { variant: 'on', attachment: {} },
      setting_test: { variant: 'default', attachment: { 'key' => 'value' } }
    }}

    before do
      allow(adapter).to receive(:call).with(**call_args).and_return(settings)
    end

    it 'expects an :entity_id argument' do
      expect { subject.load(context: nil, flags: nil) }
        .to raise_error(ArgumentError, 'missing keyword: :entity_id')
    end

    it 'expects a :context argument' do
      expect { subject.load(entity_id: nil, flags: nil) }
        .to raise_error(ArgumentError, 'missing keyword: :context')
    end

    it 'returns the data returned by the adapter' do
      data = subject.load(**call_args)
      expect(data).to eq settings
    end

    it 'stores the data returned by the adapter' do
      subject.load(**call_args)
      flag = subject.flag?(:test)

      expect(flag).to be true
    end

    context 'when the adapter fails' do
      let(:error_handler) { spy('Error Handler') }

      before do
        subject.error_handler = error_handler
        allow(adapter).to receive(:call).and_raise
      end

      it 'calls the exception handler' do
        subject.load(**call_args)
        expect(error_handler).to have_received(:call).with(StandardError)
      end

      it 'returns an empty hash' do
        data = subject.load(**call_args)
        expect(data).to eq({})
      end
    end
  end

  describe '#setting' do
    context 'when the setting is present' do
      let(:data) {{ setting_test: { attachment: { key: 'value' } } }}
      let(:setting) { subject.setting(:test) }

      it 'returns its value' do
        expect(setting).to eq(key: 'value')
      end

      context 'and a specific item of the setting is requested' do
        let(:setting) { subject.setting(:test, :key) }

        it 'returns the specified value' do
          expect(setting).to eq 'value'
        end

        context 'and its value is false' do
          let(:data) {{ setting_test: { attachment: { key: false } } }}

          it 'returns it' do
            expect(setting).to be false
          end
        end

        context 'and it is absent' do
          it 'returns nil' do
            value = subject.setting(:test, :unknown)
            expect(value).to be nil
          end

          it 'returns the default value if provided by keyword argument' do
            value = subject.setting(:test, :unknown, default: 'karg')
            expect(value).to eq 'karg'
          end

          it 'returns the default value if provided by block' do
            value = subject.setting(:test, :unknown) { 'block' }
            expect(value).to eq 'block'
          end

          it 'returns the default value from the block if both keyword and block are provided' do
            value = subject.setting(:test, :unknown, default: 'karg') { 'block' }
            expect(value).to eq 'block'
          end
        end
      end
    end

    context 'when the setting is unknown' do
      it 'returns nil' do
        expect(subject.setting(:unknown)).to be nil
      end

      it 'returns the default value if provided by keyword argument' do
        value = subject.setting(:unknown, default: 'karg')
        expect(value).to eq 'karg'
      end

      it 'returns the default value if provided by block' do
        value = subject.setting(:unknown) { 'block' }
        expect(value).to eq 'block'
      end

      it 'returns the default value from the block if both keyword and block are provided' do
        value = subject.setting(:unknown, default: 'karg') { 'block' }
        expect(value).to eq 'block'
      end

      it 'yields the setting name to the provided black' do
        expect { |b| subject.setting(:unknown, &b) }.to yield_with_args(:unknown)
      end

      context 'and a specific item of the setting is requested' do
        it 'returns nil' do
          value = subject.setting(:unknown, :key)
          expect(value).to be nil
        end

        it 'returns the default value if provided by keyword argument' do
          value = subject.setting(:unknown, :unknown, default: 'karg')
          expect(value).to eq 'karg'
        end

        it 'returns the default value if provided by block' do
          value = subject.setting(:unknown, :unknown) { 'block' }
          expect(value).to eq 'block'
        end

        it 'returns the default value from the block if both keyword and block are provided' do
          value = subject.setting(:unknown, :unknown, default: 'karg') { 'block' }
          expect(value).to eq 'block'
        end

        it 'yields the setting and property names to the provided black' do
          expect { |b| subject.setting(:unknown, :test, &b) }
            .to yield_with_args(:unknown, :test)
        end
      end
    end
  end
end
