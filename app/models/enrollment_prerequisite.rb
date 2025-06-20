class EnrollmentPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(_approved_approvable_ids)
    false
  end
end

# == Schema Information
#
# Table name: prerequisites
#
#  id                        :bigint           not null, primary key
#  amount_of_subjects_needed :integer
#  credits_needed            :integer
#  logical_operator          :string
#  type                      :string           not null
#  approvable_id             :integer
#  approvable_needed_id      :integer
#  parent_prerequisite_id    :integer
#  subject_group_id          :integer
#
