class CreditsPrerequisite < Prerequisite
  belongs_to :subject_group, optional: true

  validates :credits_needed, presence: true

  def met?(approved_courses, approved_exams)
    subjects = subject_group ? subject_group.subjects : Subject.all

    approved_credits = subjects.approved_credits(approved_courses, approved_exams)
    approved_credits >= credits_needed
  end
end
