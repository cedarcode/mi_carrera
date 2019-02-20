module SubjectsHelper
  def course_approved?(subject)
    return !session[:approved_courses].nil? && session[:approved_courses].include?(subject.id)
  end

  def exam_approved?(subject)
    return !session[:approved_exams].nil? && session[:approved_exams].include?(subject.id)
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
