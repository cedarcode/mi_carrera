class SubjectPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"

  def to_s
    self.approvable_needed.to_s
  end
end
