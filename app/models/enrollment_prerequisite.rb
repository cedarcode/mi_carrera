class EnrollmentPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(_approved_approvable_ids)
    false
  end
end
