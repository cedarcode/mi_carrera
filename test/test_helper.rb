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

  def wait_for_approvables_reloaded
    assert page.has_no_selector?('.mdc-circular-progress')
  end

  def within_actions_menu
    within '.mdc-drawer__content' do
      yield
    end
  end

  def click_actions_menu
    find(".mdc-icon-button", text: 'menu').click
  end
end
