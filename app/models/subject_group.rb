class SubjectGroup < ApplicationRecord
  belongs_to :degree
  belongs_to :degree_plan
  has_many :subjects, foreign_key: :group_id, inverse_of: :group, dependent: :restrict_with_exception
  has_many :subject_group_memberships, dependent: :destroy

  validates :name, presence: true
  validates :code, uniqueness: { scope: :degree_plan_id }
end

# == Schema Information
#
# Table name: subject_groups
#
#  id             :bigint           not null, primary key
#  code           :string
#  credits_needed :integer          default(0), not null
#  name           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  degree_id      :string           not null
#  degree_plan_id :bigint           not null
#
# Indexes
#
#  index_subject_groups_on_degree_id                (degree_id)
#  index_subject_groups_on_degree_plan_id           (degree_plan_id)
#  index_subject_groups_on_degree_plan_id_and_code  (degree_plan_id,code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (degree_id => degrees.id)
#  fk_rails_...  (degree_plan_id => degree_plans.id)
#
