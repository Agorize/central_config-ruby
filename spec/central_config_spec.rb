# frozen_string_literal: true

RSpec.describe CentralConfig do
  let(:config) { double }

  before { subject.config = config }

  describe '.flag?' do
    let(:config) { instance_double('Config', flag?: 'flag called') }

    it 'delegates to its config' do
      expect(subject.flag?).to eq 'flag called'
    end
  end

  describe '.load' do
    let(:config) { instance_double('Config', load: 'load called') }

    it 'delegates to its config' do
      expect(subject.load).to eq 'load called'
    end
  end

  describe '.setting' do
    let(:config) { instance_double('Config', setting: 'setting called') }

    it 'delegates to its config' do
      expect(subject.setting).to eq 'setting called'
    end
  end

  describe '.config' do
    it 'returns the config' do
      subject.config = 'config'
      expect(subject.config).to eq('config')
    end
  end

  describe '.config=' do
    it 'sets the config' do
      subject.config = 'config'
      expect(subject.config).to eq('config')
    end

    it 'sets the config for the current thread' do
      subject.config = 'config'
      expect(Thread.current[:central_config]).to eq('config')
    end
  end
end
