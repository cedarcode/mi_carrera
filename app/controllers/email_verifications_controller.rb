class EmailVerificationsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(id: params[:format])
    session[:user_id] = user.id
    if user.update(verified: true)
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al verificar tu correo electrónico"
      redirect_to root_path
    end
  end
end
