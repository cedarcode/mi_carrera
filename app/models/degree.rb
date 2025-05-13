class Degree < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end
