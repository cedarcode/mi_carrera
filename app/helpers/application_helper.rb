module ApplicationHelper
  def nav_icon(name, path)
    link_to(name, path, class: "material-icons mdc-top-app-bar__navigation-icon mdc-icon-button")
  end

  def action_icon(name, path)
    link_to(name, path, class: "material-icons mdc-top-app-bar__action-item mdc-icon-button")
  end

  def show_login_link?
    !user_signed_in? && !current_page?(new_user_session_path)
  end
end
