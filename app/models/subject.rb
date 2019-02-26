class Subject < ApplicationRecord
  has_one :course, -> { where is_exam: false }, class_name: 'DependencyItem'
  has_one :exam, -> { where is_exam: true }, class_name: 'DependencyItem'
end
