class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    review = current_user.reviews.find_or_initialize_by(subject_id: params[:subject_id])
    review.update!(permitted_params)
    redirect_to subject_path(review.subject)
  end

  private

  def permitted_params
    params.permit(:interesting_rating, :credits_to_difficulty_rating)
  end
end
