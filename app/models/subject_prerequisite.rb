class SubjectPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(approved_approvable_ids)
    approved_approvable_ids.include?(approvable_needed_id)
  end
end
