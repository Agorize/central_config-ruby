# frozen_string_literal: true

ENV['CENTRAL_CONFIG_FLAGR_HOST'] = 'flagr.test.com'
ENV['DATABASE_URL'] ||= 'sqlite3://localhost/:memory:'
ENV['RAILS_ENV'] = 'test'

require 'support/apps/rails_5.0'
require 'rspec/rails'

RSpec.configure(&:infer_spec_type_from_file_location!)
