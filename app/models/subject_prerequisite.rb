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
# Indexes
#
#  index_prerequisites_on_approvable_id           (approvable_id)
#  index_prerequisites_on_parent_prerequisite_id  (parent_prerequisite_id)
#
# Foreign Keys
#
#  fk_rails_...  (approvable_id => approvables.id)
#  fk_rails_...  (approvable_needed_id => approvables.id)
#  fk_rails_...  (parent_prerequisite_id => prerequisites.id)
#  fk_rails_...  (subject_group_id => subject_groups.id)
#
