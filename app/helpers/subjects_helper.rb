module SubjectsHelper
  def semester_to_text(semester)
    case semester
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
    when 9
      "Noveno"
    end
  end

  def display_name(subject)
    subject.code + ' - ' + (subject.short_name || subject.name)
  end
end
