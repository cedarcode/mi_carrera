ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def approvable_ids_in_cookie(cookie)
    JSON.parse(cookie[:approved_approvable_ids] || "[]")
    value = cookie[:approved_approvable_ids]
    value.present? ? JSON.parse(value) : nil
  end
end
