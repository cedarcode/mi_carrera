require 'rails_helper'

RSpec.describe ReviewsController, type: :request do
  let(:user) { create(:user) }
  let(:subject) { create(:subject) }
  let(:review) { create(:review, user:, subject:) }

  before do
    # https://github.com/heartcombo/devise/issues/5705
    Rails.application.reload_routes_unless_loaded
  end

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'when no review exists for that user and subject' do
      it 'creates a new review' do
        expect {
          post reviews_path, params: { subject_id: subject.id, rating: 5 }
        }.to change(Review, :count).by(1)

        expect(Review.last.rating).to eq(5)
      end

      it 'redirects to the subject page' do
        post reviews_path, params: { subject_id: subject.id, rating: 5 }

        expect(response).to redirect_to(subject_path(subject))
      end
    end

    context 'when a review already exists' do
      it 'updates the existing review' do
        review

        expect {
          post reviews_path, params: { subject_id: subject.id, rating: 4 }
        }.to change { review.reload.rating }.from(3).to(4)
      end

      it 'does not create another record' do
        review

        expect {
          post reviews_path, params: { subject_id: subject.id, rating: 4 }
        }.not_to change(Review, :count)
      end

      it 'redirects to the subject page' do
        post reviews_path, params: { subject_id: subject.id, rating: 4 }

        expect(response).to redirect_to(subject_path(subject))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the review' do
      review

      expect {
        delete review_path(review)
      }.to change(Review, :count).by(-1)
    end

    it 'redirects to the subject page' do
      delete review_path(review)

      expect(response).to redirect_to(subject_path(review.subject))
    end
  end
end
