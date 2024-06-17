class ActivityPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(approved_approvable_ids)
    approvable_needed.available?(approved_approvable_ids)
  end
end
