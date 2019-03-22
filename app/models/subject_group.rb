class SubjectGroup < ApplicationRecord
  has_many :subjects, foreign_key: :group_id

  validates :name, presence: true
end
