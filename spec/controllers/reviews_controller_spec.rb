require 'rails_helper'

RSpec.describe ReviewsController, type: :request do
  let(:user) { create(:user) }
  let(:subject) { create(:subject) }
  let(:review) { create(:review, user: user, subject: subject) }

  before do
    # https://github.com/heartcombo/devise/issues/5705
    Rails.application.reload_routes_unless_loaded
  end

  before do
    sign_in user
  end

  describe 'POST #create' do
    it 'creates a new review' do
      expect {
        post reviews_path, params: { subject_id: subject.id, rating: 5 }
      }.to change(Review, :count).by(1)
    end

    it 'redirects to the subject page' do
      post reviews_path, params: { subject_id: subject.id, rating: 5 }

      expect(response).to redirect_to(subject_path(subject))
    end
  end

  describe 'PATCH #update' do
    it 'updates the review' do
      patch review_path(review), params: { rating: 4 }

      expect(review.reload.rating).to eq(4)
    end

    it 'redirects to the subject page' do
      patch review_path(review), params: { rating: 4 }

      expect(response).to redirect_to(subject_path(review.subject))
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
