class ActivityPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(approved_approvable_ids)
    if approvable_needed.is_exam?
      approved_approvable_ids.include?(approvable_needed.subject.course.id)
    else
      true
    end
  end
end
