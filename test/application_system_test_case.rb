require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: (ENV["TEST_BROWSER"] || :headless_chrome).to_sym, screen_size: [1200, 1200]
end
