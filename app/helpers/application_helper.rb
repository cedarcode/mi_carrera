module ApplicationHelper
  def drawer_menu_navigation_item(text, link, new_badge: false)
    link_options = {}
    link_options[:tabindex] = 0

    if current_page?(link)
      link_options[:aria] = { current: 'page' }

      link_options[:class] = "flex p-2 rounded-sm text-primary bg-purple-200"
    else
      link_options[:class] = "flex p-2 rounded-sm text-gray-600 hover:text-gray-800 hover:bg-gray-100"
    end

    link_to link, **link_options do
      concat tag.span(text)
      if new_badge
        concat tag.span(
          'Nuevo',
          class: "self-center ms-3 bg-purple-100 border text-primary text-[10px] uppercase rounded-full py-0.5 px-2"
        )
      end
    end
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

  def material_icon(icon, classes = nil)
    tag.span(icon, class: "material-icons #{classes}")
  end
end
