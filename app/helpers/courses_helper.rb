module CoursesHelper
  def course_approved?(course)
    return !session[:approved_courses].nil? && session[:approved_courses].include?(course.id)
  end

  def semester_to_text(n)
    case n
    when 1
      "Primer"
    when 2
      "Segundo"
    when 3
      "Tercer"
    when 4
      "Cuarto"
    when 5
      "Quinto"
    when 6
      "Sexto"
    when 7
      "Séptimo"
    when 8
      "Octavo"
    end
  end
end
