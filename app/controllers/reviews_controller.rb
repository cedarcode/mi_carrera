class ReviewsController < ApplicationController
  def create
    if !current_user && not_localhost
      redirect_to new_user_session_path, alert: "Inicia sesión para dejar una reseña"
    else
      puts 'review params are: ', review_params
      @review = Review.new(review_params)
      not_localhost ? @review.user = current_user : @review.user = nil
      @review.save
      redirect_to root_path, notice: "Reseña creada con éxito"
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def not_localhost
    request.host != 'localhost'
  end
end
