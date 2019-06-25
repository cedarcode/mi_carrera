class CreditsPrerequisite < Prerequisite
  belongs_to :subject_group, optional: true

  validates :credits_needed, presence: true

  def to_s
    if self.subject_group
      self.credits_needed.to_s + " créditos en " + self.subject_group.name
    else
      self.credits_needed.to_s + " créditos totales"
    end
  end
end
