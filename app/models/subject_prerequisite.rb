class SubjectPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(approved_courses, approved_exams)
    approved_ids = approvable_needed.is_exam ? approved_exams : approved_courses
    approved_ids.include?(approvable_needed.subject_id)
  end
end
