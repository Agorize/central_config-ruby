# frozen_string_literal: true

module CentralConfigHelper
  def central_flag?(flag_name, default: false, &block)
    CentralConfig.flag?(flag_name, default: default, &block)
  end

  def central_setting(setting_name, *dig_path, default: nil, &block)
    CentralConfig.setting(setting_name, *dig_path, default: default, &block)
  end
end
