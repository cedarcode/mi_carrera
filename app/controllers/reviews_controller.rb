class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:destroy]

  def create
    @review = current_user.reviews.find_or_initialize_by(subject_id: params[:subject_id])
    @review.update!(rating: params[:rating], recommend: params[:recommend], interest: params[:interest])

    redirect_to subject_path(@review.subject)
  end

  def update
    @review = current_user.reviews.find(params[:id])
    @review.update!(rating: params[:rating], recommend: params[:recommend], interest: params[:interest])

    redirect_to subject_path(@review.subject)
  end

  def destroy
    @review.destroy!

    redirect_to subject_path(@review.subject)
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end
end
