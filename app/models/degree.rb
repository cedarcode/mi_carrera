class Degree < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :key, presence: true, uniqueness: true
end
