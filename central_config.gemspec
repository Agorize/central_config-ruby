# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'central_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'central_config'
  spec.version       = CentralConfig::VERSION
  spec.authors       = ['Simon Courtois']
  spec.email         = ['simon@agorize.com']

  spec.summary       = 'Access to centralized feature flags and settings for Agorize.'
  spec.license       = 'Copyright'
  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'actionpack', '~> 5.1.5'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'capybara', '~> 3.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.64.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.32'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
  spec.add_development_dependency 'webmock', '~> 3.5'

  spec.add_runtime_dependency 'activesupport', '~> 5.1'
  spec.add_runtime_dependency 'rbflagr', '~> 0.2.0'
end
