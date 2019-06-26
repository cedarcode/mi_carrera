class CreditsPrerequisite < Prerequisite
  belongs_to :subject_group, optional: true

  validates :credits_needed, presence: true
end
