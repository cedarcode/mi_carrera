class Approvable < ApplicationRecord
  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite"

  validates :is_exam, inclusion: { in: [true, false] }

  def to_s
    res = ""
    res += (self.subject.short_name ||  self.subject.name)
    res += " (" + (self.is_exam ? "examen" : "curso") + ")"
    res
  end
end
