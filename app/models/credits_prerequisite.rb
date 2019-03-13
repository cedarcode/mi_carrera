class CreditsPrerequisite < ApplicationRecord
  belongs_to :dependency_item
  belongs_to :subjects_group
end
