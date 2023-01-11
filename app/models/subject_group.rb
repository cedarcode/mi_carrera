class SubjectGroup < ApplicationRecord
  has_many :subjects, foreign_key: :group_id, inverse_of: :group

  validates :name, presence: true
  validates :code, uniqueness: true
end
