class SubjectPrerequisite < Prerequisite
  belongs_to :approvable_needed, class_name: "Approvable"
end
