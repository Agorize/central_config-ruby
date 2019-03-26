# frozen_string_literal: true

module CentralConfig
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copy CentralConfig initializer'
      source_root "#{__dir__}/templates"

      def copy_initializer
        copy_file 'initializer.rb', 'config/initializers/central_config.rb'
      end
    end
  end
end
