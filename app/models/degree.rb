class Degree < ApplicationRecord
  has_many :subjects, dependent: :restrict_with_exception
  has_many :subject_groups, dependent: :restrict_with_exception

  validates :title, presence: true
  validates :name, presence: true, uniqueness: true
  validates :current_plan, presence: true
  validates :include_inco_subjects, inclusion: [false, true]

  def self.default
    Degree.find_by(name: "computacion")
  end
end
