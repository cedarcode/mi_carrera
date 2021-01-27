class SessionsController < ApplicationController
  def new
  end

  def create_callback
    google_identity = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
    user = User.find_by(email_address: google_identity.email_address)
    if user
      sign_in(user.id)
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al ingresar"
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def create
    user = User.find_by(email_address: params[:email])
    if user and user.authenticate(params[:password]) and user.verified
      sign_in(user.id)
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al ingresar"
      redirect_to new_session_path
    end
  end
end
