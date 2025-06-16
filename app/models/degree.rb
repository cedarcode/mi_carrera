class Degree < ApplicationRecord
  has_many :subjects, dependent: :destroy
  has_many :subject_groups, dependent: :destroy

  validates :title, presence: true
  validates :name, presence: true, uniqueness: true
  validates :current_plan, presence: true
  validates :include_inco_subjects, inclusion: [false, true]

  def self.default
    Degree.find_by(name: "computacion")
  end
end
