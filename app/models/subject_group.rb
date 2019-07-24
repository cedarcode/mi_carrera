class SubjectGroup < ApplicationRecord
  has_many :subjects, foreign_key: :group_id, dependent: :destroy

  validates :name, presence: true
  validates :code, uniqueness: true
end
