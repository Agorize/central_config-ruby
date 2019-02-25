# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CentralConfigHelper, :stub_flagr do
  before do
    CentralConfig.load(entity_id: '1', context: {}, flags: %w[flag_test setting_test])
  end

  describe '#central_flag?' do
    it 'returns the right value for the flag' do
      expect(helper.central_flag?(:test)).to be true
    end

    context 'when the flag is unknown' do
      it 'returns the default value if provided by keyword argument' do
        value = helper.central_flag?(:unknown, default: 'karg')
        expect(value).to eq 'karg'
      end

      it 'returns the default value if provided by block' do
        value = helper.central_flag?(:unknown) { 'block' }
        expect(value).to eq 'block'
      end

      it 'returns the default value from the block if both keyword and block are provided' do
        value = helper.central_flag?(:unknown, default: 'karg') { 'block' }
        expect(value).to eq 'block'
      end
    end
  end

  describe '#central_setting' do
    it 'returns the right value for the setting' do
      expect(helper.central_setting(:test)).to eq(title: 'Agorize', live: false)
    end

    context 'when a specific item of the setting is requested' do
      let(:setting) { helper.central_setting(:test, :title) }

      it 'returns the specified value if it is present' do
        expect(setting).to eq 'Agorize'
      end

      context 'and its value is false' do
        let(:setting) { helper.central_setting(:test, :live) }

        it 'returns it' do
          expect(setting).to be false
        end
      end

      context 'and it is absent' do
        it 'returns nil' do
          value = helper.central_setting(:test, :unknown)
          expect(value).to be nil
        end

        it 'returns the default value if provided by keyword argument' do
          value = helper.central_setting(:test, :unknown, default: 'karg')
          expect(value).to eq 'karg'
        end

        it 'returns the default value if provided by block' do
          value = helper.central_setting(:test, :unknown) { 'block' }
          expect(value).to eq 'block'
        end

        it 'returns the default value from the block if both keyword and block are provided' do
          value = helper.central_setting(:test, :unknown, default: 'karg') { 'block' }
          expect(value).to eq 'block'
        end
      end
    end

    context 'when the setting is unknown' do
      it 'returns the default value if provided by keyword argument' do
        value = helper.central_setting(:unknown, default: 'karg')
        expect(value).to eq 'karg'
      end

      it 'returns the default value if provided by block' do
        value = helper.central_setting(:unknown) { 'block' }
        expect(value).to eq 'block'
      end

      it 'returns the default value from the block if both keyword and block are provided' do
        value = helper.central_setting(:unknown, default: 'karg') { 'block' }
        expect(value).to eq 'block'
      end
    end
  end
end
