class CreditsPrerequisite < ApplicationRecord
  belongs_to :dependency_item
  belongs_to :subject_group, optional: true
end
