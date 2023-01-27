class CreditsPrerequisite < Prerequisite
  belongs_to :subject_group, optional: true

  validates :credits_needed, presence: true

  def met?(approved_approvable_ids)
    subjects = subject_group ? subject_group.subjects : Subject.all

    approved_credits = subjects.approved_credits(approved_approvable_ids)
    approved_credits >= credits_needed
  end
end
