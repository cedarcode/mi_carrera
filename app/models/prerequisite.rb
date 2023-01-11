class Prerequisite < ApplicationRecord
  after_create :reload_subjects
  belongs_to :parent_prerequisite, class_name: 'Prerequisite', optional: true
  belongs_to :approvable, optional: true

  def reload_subjects
    Bedel.reload_subjects
  end
end
