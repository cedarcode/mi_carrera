class SessionsController < ApplicationController
  def new
  end

  def create_callback
    google_identity = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
    user = User.find_by(email_address: google_identity.email_address)
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al iniciar sesión"
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
