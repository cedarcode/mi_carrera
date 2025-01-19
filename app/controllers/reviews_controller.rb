class ReviewsController < ApplicationController
  def new
    if !current_user && not_localhost
      redirect_to new_user_session_path, alert: "Inicia sesión para dejar una reseña."
    else
      render :new  
    end
  end


  def create
    @review = Review.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @review, notice: "Reseña añadida."
    else
      render :new, alert: "Error añadiendo tu reseña."
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
