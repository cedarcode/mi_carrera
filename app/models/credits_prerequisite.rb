class CreditsPrerequisite < ApplicationRecord
  belongs_to :dependency_item
  belongs_to :subject_group, optional: true

  validates :credits_needed, presence: true
end
