class Review < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, uniqueness: { scope: :subject_id, message: "You can only review a subject once." }
  validates :interesting_rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :credits_to_difficulty_rating, inclusion: { in: 1..5 }, allow_nil: true
end

# == Schema Information
#
# Table name: reviews
#
#  id                           :bigint           not null, primary key
#  credits_to_difficulty_rating :integer
#  interesting_rating           :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  subject_id                   :bigint           not null
#  user_id                      :bigint           not null
#
# Indexes
#
#  index_reviews_on_subject_id_and_user_id  (subject_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#  fk_rails_...  (user_id => users.id)
#
