require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: (ENV["TEST_BROWSER"] || :headless_chrome).to_sym, screen_size: [1200, 1200]

  def check_approvable(approvable)
    check dom_id(approvable), visible: false
    assert_approvable_checkbox(approvable, checked: true)
  end

  def uncheck_approvable(approvable)
    uncheck dom_id(approvable), visible: false
    assert_approvable_checkbox(approvable, checked: false)
  end

  def assert_approvable_checkbox(approvable, **opts)
    assert_selector(:field, dom_id(approvable), **opts.merge(visible: false))
  end
end
