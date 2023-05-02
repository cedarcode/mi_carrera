class EnrollmentPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(approved_approvable_ids)
    false
  end
end
