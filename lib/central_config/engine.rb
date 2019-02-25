# frozen_string_literal: true

module CentralConfig
  class Engine < ::Rails::Engine
    # Register CentralConfig as a Rails helper
    initializer 'central_config.action_controller' do
      ::ActiveSupport.on_load :action_controller do
        ::ActionController::Base.include CentralConfigHelper
      end
    end
  end
end
