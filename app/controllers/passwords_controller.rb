class PasswordsController < ApplicationController
  def new
    @user = User.find_by(password_reset_token: params[:t])

    if !@user
      redirect_to root_path
    end
  end

  def create
    raise "Freak out" if params[:t].blank?

    user = User.find_by!(password_reset_token: params[:t])

    if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to new_session_path
    else
      flash[:error] = "Ocurrió un error al restablecer la contraseña"
      redirect_to new_password_path(t: params[:t])
    end
  end
end
