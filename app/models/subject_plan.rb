class SubjectPlan < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :subject_id, uniqueness: { scope: :user_id }
  validates :semester, numericality: { only_integer: true, greater_than: 0 }
end

# == Schema Information
#
# Table name: subject_plans
#
#  id         :bigint           not null, primary key
#  semester   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_subject_plans_on_user_id_and_subject_id  (user_id,subject_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (user_id => users.id)
#
