module SubjectsHelper
  CATEOGIRES_SORT_ORDER = {
    first_semester: 1,
    second_semester: 2,
    third_semester: 3,
    fourth_semester: 4,
    fifth_semester: 5,
    sixth_semester: 6,
    seventh_semester: 7,
    eighth_semester: 8,
    nineth_semester: 9,
    optional: 10,
    inactive: 11,
    revalid: 12,
  }

  def subjects_grouped_by_category(subjects)
    subjects.group_by(&:category).sort_by { |key, _value| CATEOGIRES_SORT_ORDER[key] }.to_h
  end

  def formatted_category(category)
    case category
    when :first_semester then 'Primer semestre'
    when :second_semester then 'Segundo semestre'
    when :third_semester then 'Tercer semestre'
    when :fourth_semester then 'Cuarto semestre'
    when :fifth_semester then 'Quinto semestre'
    when :sixth_semester then 'Sexto semestre'
    when :seventh_semester then 'Séptimo semestre'
    when :eighth_semester then 'Octavo semestre'
    when :nineth_semester then 'Noveno semestre'
    when :inactive then 'Materias inactivas'
    when :optional then 'Materias opcionales'
    when :revalid then 'Reválidas'
    end
  end

  def display_name(subject)
    "#{subject.code} - #{subject.short_name || subject.name}"
  end

  def display_subject_prerequisite(subject_prerequisite)
    approvable = subject_prerequisite.approvable_needed
    "#{display_name(approvable.subject)} (#{approvable.is_exam ? "examen" : "curso"})"
  end
end
