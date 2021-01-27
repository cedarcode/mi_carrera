class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email])
    if user
      session[:email] = user.email_address
      PasswordResetsMailer.password_reset(user).deliver
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al restablecer la contraseña"
      redirect_to new_password_resets_path
    end
  end
end
