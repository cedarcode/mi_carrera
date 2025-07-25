module SubjectsHelper
  def formatted_category(category)
    case category
    when 'first_semester' then 'Primer semestre'
    when 'second_semester' then 'Segundo semestre'
    when 'third_semester' then 'Tercer semestre'
    when 'fourth_semester' then 'Cuarto semestre'
    when 'fifth_semester' then 'Quinto semestre'
    when 'sixth_semester' then 'Sexto semestre'
    when 'seventh_semester' then 'Séptimo semestre'
    when 'eighth_semester' then 'Octavo semestre'
    when 'nineth_semester' then 'Noveno semestre'
    when 'inactive' then 'Materias inactivas'
    when 'optional' then 'Materias opcionales'
    when 'revalid' then 'Reválidas'
    when 'outside_montevideo' then 'Materias dictadas en institutos del interior'
    when 'extension_module' then 'Módulos de taller y extensión'
    end
  end

  def semester_display_name(semester)
    "Semestre #{semester}"
  end

  def display_name(subject)
    "#{subject.code} - #{subject.short_name || subject.name}"
  end

  def display_subject_prerequisite(subject_prerequisite)
    approvable = subject_prerequisite.approvable_needed
    "#{display_name(approvable.subject)} (#{approvable.is_exam ? "examen" : "curso"})"
  end

  def display_enrollment_prerequisite(enrollment_prerequisite)
    approvable = enrollment_prerequisite.approvable_needed
    "inscripto a #{approvable.is_exam ? "examen" : "curso"} de #{display_name(approvable.subject)}"
  end

  def display_activity_prerequisite(activity_prerequisite)
    "aprobado/reprobado #{display_subject_prerequisite(activity_prerequisite)}"
  end
end
