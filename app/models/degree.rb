class Degree < ApplicationRecord
  has_many :subjects, dependent: :restrict_with_exception
  has_many :subject_groups, dependent: :restrict_with_exception

  validates :current_plan, presence: true

  def self.default
    Degree.find_by(id: "computacion")
  end
end
