class SubjectPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def met?(approved_approvable_ids)
    approved_approvable_ids.include?(approvable_needed_id)
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
