class Approvable < ApplicationRecord
  belongs_to :subject
  has_one :prerequisite_tree, class_name: "Prerequisite", dependent: :destroy

  validates :is_exam, inclusion: { in: [true, false] }

  def approved?(approved_approvable_ids)
    approved_approvable_ids.include?(id)
  end

  def available?(approved_approvable_ids)
    if prerequisite_tree
      prerequisite_tree.met?(approved_approvable_ids)
    else
      true
    end
  end
end

# == Schema Information
#
# Table name: approvables
#
#  id         :bigint           not null, primary key
#  is_exam    :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subject_id :integer          not null
#
