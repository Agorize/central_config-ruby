# frozen_string_literal: true

require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_view/testing/resolvers'

require 'central_config'

module Rails50
  class Application < Rails::Application
    config.root = File.expand_path('../..', __dir__)
    config.cache_classes = true
    config.eager_load = false
    config.public_file_server.enabled = true
    config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=3600' }
    config.condiser_all_requests_local = true
    config.action_controller.perform_caching = false
    config.action_dispatch.show_exceptions = false
    config.action_controller.allow_forgery_protection = false
    config.active_support.deprecation = :stderr
    config.middleware.delete Rack::Lock
    config.middleware.delete ActionDispatch::Flash
    config.secret_key_base = 'xxx123xxx'

    routes.append do
      get '/flag' => 'testing#flag'
      get '/setting' => 'testing#setting'
    end
  end
end

Rails50::Application.initialize!

class TestingController < ActionController::Base
  include Rails.application.routes.url_helpers
  layout 'application'
  self.view_paths = [
    ActionView::FixtureResolver.new(
      'layouts/application.html.erb' => '<%= yield %>',
      'testing/flag.html.erb' => '<% if central_flag?(:test) %>Working<% end %>',
      'testing/setting.html.erb' => '<%= central_setting(:test, :title) %>')
  ]

  before_action do
    CentralConfig.load(entity_id: '1', context: {})
  end
end
