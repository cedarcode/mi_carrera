class DegreePlan < ApplicationRecord
  belongs_to :degree
  has_many :subjects, dependent: :restrict_with_exception
  has_many :subject_groups, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { scope: :degree_id }

  scope :active, -> { where(active: true) }
  scope :ordered_by_degree_name, -> { joins(:degree).order("degrees.name", :name) }

  def self.default
    Degree.default&.active_degree_plan
  end
end

# == Schema Information
#
# Table name: degree_plans
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  degree_id  :string           not null
#
# Indexes
#
#  index_degree_plans_on_degree_id_and_name  (degree_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (degree_id => degrees.id)
#
