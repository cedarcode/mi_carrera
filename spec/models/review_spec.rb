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
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..5).allow_nil }
  end

  describe '.review_fields' do
    it 'returns the correct review fields' do
      expect(Review.review_fields).to contain_exactly(:rating, :recommended)
    end

    it 'excludes standard ActiveRecord attributes' do
      expect(Review.review_fields).not_to include(:id, :user_id, :subject_id, :created_at, :updated_at)
    end
  end

  describe '#would_be_blank_without?' do
    let(:review) { build(:review, rating: 4, recommended: true) }

    it 'returns false when other fields have values' do
      expect(review.would_be_blank_without?([:rating])).to be false
    end

    it 'returns true when all other fields would be nil' do
      review.recommended = nil
      expect(review.would_be_blank_without?([:rating])).to be true
    end

    it 'returns false when no fields are excluded and review has values' do
      expect(review.would_be_blank_without?).to be false
    end
  end

  describe '#smart_update!' do
    let(:user) { create(:user) }
    let(:subject) { create(:subject) }
    let(:review) { create(:review, user: user, subject: subject, rating: 4, recommended: true) }

    context 'when updating to valid values' do
      it 'updates the review successfully' do
        review.smart_update!(rating: 5)

        expect(review.reload.rating).to eq(5)
        expect(review.destroyed?).to be false
        expect(Review.exists?(review.id)).to be true
      end
    end

    context 'when updating would make all fields blank' do
      it 'destroys the review' do
        review_id = review.id
        review.smart_update!(rating: nil, recommended: nil)

        expect(review.destroyed?).to be true
        expect(Review.exists?(review_id)).to be false
      end
    end

    context 'when update fails validation' do
      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          review.smart_update!(rating: 10) # Invalid rating
        }.to raise_error(ActiveRecord::RecordInvalid)

        expect(review.reload.rating).to eq(4) # Unchanged
      end
    end
  end
end
