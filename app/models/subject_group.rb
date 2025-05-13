class SubjectGroup < ApplicationRecord
  acts_as_tenant :degree

  has_many :subjects, foreign_key: :group_id, inverse_of: :group, dependent: :restrict_with_exception

  validates :name, presence: true
  validates_uniqueness_to_tenant :code
end
