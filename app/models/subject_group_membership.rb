class SubjectGroupMembership < ApplicationRecord
  belongs_to :subject
  belongs_to :group, class_name: 'SubjectGroup', foreign_key: 'subject_group_id', inverse_of: :subject_group_memberships

  validates :credits, presence: true
end

# == Schema Information
#
# Table name: subject_group_memberships
#
#  id               :bigint           not null, primary key
#  credits          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subject_group_id :bigint           not null
#  subject_id       :bigint           not null
#
# Indexes
#
#  index_subject_group_memberships_on_subject_and_group  (subject_id,subject_group_id) UNIQUE
#  index_subject_group_memberships_on_subject_group_id   (subject_group_id)
#  index_subject_group_memberships_on_subject_id         (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_group_id => subject_groups.id)
#  fk_rails_...  (subject_id => subjects.id)
#
