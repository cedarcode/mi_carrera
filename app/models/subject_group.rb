class SubjectGroup < ApplicationRecord
  belongs_to :degree, optional: true
  has_many :subjects, foreign_key: :group_id, inverse_of: :group, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :code, uniqueness: { scope: :degree_id }
end
