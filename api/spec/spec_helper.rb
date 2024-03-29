if ENV["COVERAGE"]
  # Run Coverage report
  require 'simplecov'
  SimpleCov.start do
    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Views', 'app/views'
    add_group 'Libraries', 'lib'
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

begin
  require File.expand_path("../dummy/config/environment", __FILE__)
rescue LoadError
  puts "Could not load dummy application. Please ensure you have run `bundle exec rake test_colibri`"
  exit
end

require 'rspec/rails'
require 'rspec/autorun'
require 'ffaker'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

require 'colibri/testing_support/factories'
require 'colibri/testing_support/preferences'

require 'colibri/api/testing_support/caching'
require 'colibri/api/testing_support/helpers'
require 'colibri/api/testing_support/setup'

RSpec.configure do |config|
  config.backtrace_exclusion_patterns = [/gems\/activesupport/, /gems\/actionpack/, /gems\/rspec/]
  config.color = true

  config.include FactoryGirl::Syntax::Methods
  config.include Colibri::Api::TestingSupport::Helpers, :type => :controller
  config.extend Colibri::Api::TestingSupport::Setup, :type => :controller
  config.include Colibri::TestingSupport::Preferences, :type => :controller

  config.fail_fast = ENV['FAIL_FAST'] || false

  config.before do
    Colibri::Api::Config[:requires_authentication] = true
  end

  config.use_transactional_fixtures = true
end
