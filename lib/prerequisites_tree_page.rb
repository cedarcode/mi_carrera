class PrerequisitesTreePage < BedeliasPage
  def root
    find("//td[@data-rowkey='root']")
  end

  def back
    find("//button/span[text()='Volver']").click
  end

  def extract_subjects_from(box)
    subjects = []
    text = box.split('entre: ')[1]

    indices =
      text
      .enum_for(:scan, /(?=((Examen)|(Curso)|(U\.C\.B aprobada)))/)
      .map { Regexp.last_match.offset(0).first } # all indices of 'Exam', 'Curso' and 'U.C.B aprobada'

    (0..(indices.count - 1)).each do |i|
      last = (i == indices.count - 1 ? text.length : indices[i + 1])
      last -= 1
      subject = text[indices[i]..last]

      subject_code = subject.match(/([\dA-Z]+ - )?([\dA-Z]+) -/)[2]

      subject_code = subject_code.tr(' -', '')
      if subject.include?("U.C.B aprobada:")
        needs = 'all'
      elsif subject.include?("Examen")
        needs = 'exam'
      elsif subject.include?("Curso")
        needs = 'course'
      end
      subjects += [{ subject_needed: subject_code, needs: needs }]
    end
    subjects
  end
end
