class AppReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    params = app_review_params

    if params[:content].blank? || params[:rating].blank?
      puts 'redirigiendo a root_path'
      redirect_to root_path, alert: "Debes elegir una calificación y escribir una opinión"; return
    end

    @app_review = AppReview.new(params)
    @app_review.user = current_user
    @app_review.save

    redirect_to root_path, notice: "Reseña creada con éxito"
  end

  def index
    @app_reviews = AppReview.all
  end

  private

  def app_review_params
    params.require(:app_review).permit(:content, :rating)
  end
end
