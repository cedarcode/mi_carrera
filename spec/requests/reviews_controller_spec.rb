require 'rails_helper'

RSpec.describe ReviewsController, type: :request do
  let(:user) { create(:user) }
  let(:subject_record) { create(:subject) }
  let(:review) { create(:review, user:, subject: subject_record) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'when no review exists for that user and subject' do
      it 'creates a new review' do
        expect {
          post reviews_path,
               params: {
                 subject_id: subject_record.id, interesting_rating: 3, credits_to_difficulty_rating: 1
               }
        }.to change(Review, :count).by(1)

        expect(Review.last.interesting_rating).to eq(3)
        expect(Review.last.credits_to_difficulty_rating).to eq(1)
      end

      it 'redirects to the subject page' do
        post reviews_path, params: { subject_id: subject_record.id, interesting_rating: 3 }

        expect(response).to redirect_to(subject_path(subject_record))
      end
    end

    context 'when a review already exists' do
      it 'updates the existing review' do
        review

        post reviews_path,
             params: {
               subject_id: subject_record.id, interesting_rating: 3, credits_to_difficulty_rating: 1
             }

        expect(review.reload.interesting_rating).to eq(3)
        expect(review.reload.credits_to_difficulty_rating).to eq(1)
      end

      it 'updates the existing review with nil values' do
        review.update!(interesting_rating: 3, credits_to_difficulty_rating: 1)

        post reviews_path,
             params: {
               subject_id: subject_record.id, interesting_rating: nil, credits_to_difficulty_rating: nil
             }

        expect(review.reload.interesting_rating).to be_nil
        expect(review.reload.credits_to_difficulty_rating).to be_nil
      end

      it 'does not create another record' do
        review

        expect {
          post reviews_path, params: { subject_id: subject_record.id, interesting_rating: 3 }
        }.not_to change(Review, :count)
      end

      it 'redirects to the subject page' do
        post reviews_path, params: { subject_id: subject_record.id, interesting_rating: 3 }

        expect(response).to redirect_to(subject_path(subject_record))
      end
    end
  end
end
