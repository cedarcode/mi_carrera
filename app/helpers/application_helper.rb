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

  def drawer_menu_navigation_item(text, link)
    link_options = {}
    link_options[:tabindex] = 0
    link_options[:class] = "mdc-deprecated-list-item"
    if current_page?(link)
      link_options[:aria] = { current: 'page' }

      link_options[:class] += " mdc-deprecated-list-item--activated"
    end

    link_to link, **link_options do
      tag.span(class: 'mdc-deprecated-list-item__ripple') +
        tag.span(text, class: 'mdc-deprecated-list-item__text')
    end
  end
end
