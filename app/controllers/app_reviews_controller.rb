class AppReviewsController < ApplicationController
  def create
    if !current_user && !localhost
      redirect_to new_user_session_path, alert: "Inicia sesión para dejar una reseña"
    else
      if app_review_params[:content].blank? || app_review_params[:rating].blank?
        redirect_to root_path, alert: "Debes elegir una calificación y escribir una opinión"
      end

      @app_review = AppReview.new(app_review_params)

      if localhost
        current_user = User.first_or_create(email: 'test@example.com', password: 'password')
      end

      @app_review.user = current_user
      @app_review.save
      redirect_to root_path, notice: "Reseña creada con éxito"
    end
  end

  def index
    @app_reviews = AppReview.all
  end

  private

  def app_review_params
    params.require(:app_review).permit(:content, :rating)
  end

  def localhost
    request.host == 'localhost'
  end
end
