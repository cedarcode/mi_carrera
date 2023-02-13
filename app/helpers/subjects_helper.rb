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
    "#{subject.code} - #{subject.short_name || subject.name}"
  end

  def display_subject_prerequisite(subject_prerequisite)
    approvable = subject_prerequisite.approvable_needed
    "#{display_name(approvable.subject)} (#{approvable.is_exam ? "examen" : "curso"})"
  end

  def approvable_disabled?(student, approvable)
    !student.available?(approvable) && !student.approved?(approvable)
  end
end
