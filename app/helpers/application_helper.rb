module ApplicationHelper
  def nav_icon(name, path)
    link_to(name, path, class: "material-icons mdc-top-app-bar__navigation-icon mdc-icon-button")
  end

  def action_icon(name, path)
    link_to(name, path, class: "material-icons mdc-top-app-bar__action-item mdc-icon-button")
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def log_out
    session[:user_id] = nil
  end
end
