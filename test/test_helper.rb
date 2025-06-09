require 'simplecov'
SimpleCov.command_name "Minitest"
SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
Dir[Rails.root.join("test/support/*")].each { |f| require f }

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end
