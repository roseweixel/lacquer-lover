require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
#require 'simplecov'
require 'database_cleaner'
require 'rubygems'
require File.expand_path("../../config/environment", __FILE__)
require 'support/integration_spec_helper'

include ActionDispatch::TestProcess

#SimpleCov.start
ENV["RAILS_ENV"] ||= 'test'
class ActiveRecord::Base  
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end  
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
ActionController::Base.asset_host = "http://localhost:3000"

OmniAuth.config.test_mode = true
omniauth_hash = {
  provider: 'facebook',
  uid: '12345',
  info: {
    name: "Lucy Lacquers",
    email:      "test@example.com"
  },
  credentials: {
    token: "123456",
    expires_at: Time.now + 1.week
  },
  extra: {
    raw_info: {
      gender: 'female'
    }
  }
}

OmniAuth.config.add_mock(:facebook, omniauth_hash)

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.include IntegrationSpecHelper, :type => :request
end

#Capybara.default_host = 'http://example.org'

# OmniAuth.config.test_mode = true
# OmniAuth.config.add_mock(:facebook, {
#   :uid => '12345',
#   :nickname => 'lucylacquers'
# })
