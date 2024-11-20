class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:update, :destroy]

  def create
    @review = current_user.reviews.create!(subject_id: params[:subject_id], rating: params[:rating])

    redirect_to subject_path(@review.subject)
  end

  def update
    @review.update!(rating: params[:rating])

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
