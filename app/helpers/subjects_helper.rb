module SubjectsHelper
  def semester_to_text(semester)
    case semester
    when 1
      "Primer semestre"
    when 2
      "Segundo semestre"
    when 3
      "Tercer semestre"
    when 4
      "Cuarto semestre"
    when 5
      "Quinto semestre"
    when 6
      "Sexto semestre"
    when 7
      "Séptimo semestre"
    when 8
      "Octavo semestre"
    when nil
      "Materias optativas"
    end
  end
end
