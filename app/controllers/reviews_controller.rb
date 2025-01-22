class ReviewsController < ApplicationController
  def create
    if !current_user && !localhost
      redirect_to new_user_session_path, alert: "Inicia sesión para dejar una reseña"
    else
      if review_params[:content].blank? || review_params[:rating].blank?
        redirect_to root_path, alert: "Debes elegir una calificación y escribir una opinión"
      end
      
      @review = Review.new(review_params)

      if localhost
        current_user = User.first_or_create(email: 'test@example.com', password: 'password')
      end

      @review.user = current_user
      @review.save
      redirect_to root_path, notice: "Reseña creada con éxito"
    end
  end

  def index
    @reviews = Review.all
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def localhost
    request.host == 'localhost'
  end
end
