class Prerequisite < ApplicationRecord
  belongs_to :prerequisite, optional: true
  belongs_to :dependency_item, optional: true
end
