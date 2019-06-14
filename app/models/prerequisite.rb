class Prerequisite < ApplicationRecord
  belongs_to :parent_prerequisite, class_name: 'Prerequisite', optional: true
  belongs_to :approvable, optional: true
end
