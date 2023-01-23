class SubjectGroup < ApplicationRecord
  has_many :subjects, foreign_key: :group_id, inverse_of: :group, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :code, uniqueness: true
end
