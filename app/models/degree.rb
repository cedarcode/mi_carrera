class Degree < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :subjects, dependent: :destroy
  has_many :subject_groups, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.default
    Degree.find_by(name: "computacion")
  end
end
