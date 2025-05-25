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

  describe '#all_review_fields_blank?' do
    let(:review) { build(:review, rating: 4, recommended: true) }

    it 'returns false when fields have values' do
      expect(review.all_review_fields_blank?).to be false
    end

    it 'returns true when all fields are nil' do
      review.rating = nil
      review.recommended = nil
      expect(review.all_review_fields_blank?).to be true
    end
  end

  describe 'after_save callback: destroy_if_all_fields_blank' do
    let(:user) { create(:user) }
    let(:subject) { create(:subject) }
    let(:review) { create(:review, user: user, subject: subject, rating: 4, recommended: true) }

    context 'when updating to valid values' do
      it 'keeps the review' do
        review.update!(rating: 5)
        
        expect(review.reload.rating).to eq(5)
        expect(Review.exists?(review.id)).to be true
      end
    end

    context 'when updating makes all fields blank' do
      it 'automatically destroys the review' do
        review_id = review.id
        review.update!(rating: nil, recommended: nil)
        
        expect(Review.exists?(review_id)).to be false
      end
    end

    context 'when creating a review with all blank fields' do
      it 'fails validation before the callback runs' do
        expect {
          Review.create!(user: user, subject: subject, rating: nil, recommended: nil)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
