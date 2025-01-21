require "test_helper"

class ApplicationControllerTestCase < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # TODO: remove when Devise fixes https://github.com/heartcombo/devise/issues/5705
  setup do
    Rails.application.reload_routes_unless_loaded
  end
end
