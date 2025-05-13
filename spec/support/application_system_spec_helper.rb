module ApplicationSystemSpecHelper
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

  def click_user_menu
    find("#user-menu[data-controller-connected='true']").click
  end

  def click_search_trigger
    find("#searchIcon").click
  end
end
