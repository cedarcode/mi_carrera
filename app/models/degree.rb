class Degree < ApplicationRecord
  has_many :degree_plans, dependent: :restrict_with_exception

  has_one :active_degree_plan, -> { active },
          class_name: "DegreePlan",
          dependent: :restrict_with_exception,
          inverse_of: :degree

  validates :current_plan, presence: true

  def self.default
    Degree.find_by(id: "computacion")
  end
end

# == Schema Information
#
# Table name: degrees
#
#  id           :string           not null, primary key
#  current_plan :string           not null
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
