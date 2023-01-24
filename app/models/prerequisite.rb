class Prerequisite < ApplicationRecord
  belongs_to :parent_prerequisite, class_name: 'Prerequisite', optional: true
  belongs_to :approvable, optional: true

  def met?(_approved_approvable_ids)
    raise NotImplementedError
  end
end
