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

    if current_page?(link)
      link_options[:aria] = { current: 'page' }

      link_options[:class] = "flex p-2 rounded-sm text-primary bg-purple-200"
    else
      link_options[:class] = "flex p-2 rounded-sm text-gray-600 hover:text-gray-800 hover:bg-gray-100"
    end

    link_to text, link, **link_options
  end

  def logical_prerequisite_description(prerequisite, negative)
    case prerequisite.logical_operator
    when "or"
      negative ? "Ninguno de los siguientes" : "Alguno de los siguientes"
    when "and"
      negative ? "Al menos uno de los siguientes sin cumplir" : "Todos los siguientes"
    when "at_least"
      "Debe tener #{negative ? 'menos de' : 'al menos'} #{prerequisite.amount_of_subjects_needed} de los siguientes"
    else
      raise "Unexpected logical operator: #{prerequisite.logical_operator}"
    end
  end
end
