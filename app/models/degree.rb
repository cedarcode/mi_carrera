class Degree < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :subjects, dependent: :destroy
  has_many :subject_groups, dependent: :destroy

  validates :key, presence: true, uniqueness: true
end
