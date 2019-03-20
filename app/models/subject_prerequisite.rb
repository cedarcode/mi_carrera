class SubjectPrerequisite < Prerequisite
  belongs_to :dependency_item_needed, class_name: "DependencyItem"
end
