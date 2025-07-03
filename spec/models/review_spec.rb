require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:subject) }
  end

  describe 'validations' do
    subject { create :review }

    it {
      is_expected.to validate_uniqueness_of(:user_id)
        .scoped_to(:subject_id)
        .with_message("You can only review a subject once.")
    }

    it { is_expected.to validate_inclusion_of(:interesting_rating).in_range(1..5).allow_nil }
    it { is_expected.to validate_inclusion_of(:credits_to_difficulty_rating).in_range(1..5).allow_nil }
  end
end
