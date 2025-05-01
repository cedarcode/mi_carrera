class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:destroy]

  def create
    review = current_user.reviews.find_or_initialize_by(subject_id: params[:subject_id])
    review.update!(permitted_params)

    redirect_to subject_path(review.subject)
  end

  def destroy
    @review.destroy!

    redirect_to subject_path(@review.subject)
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def permitted_params
    params.permit(:rating, :recommended)
  end
end
