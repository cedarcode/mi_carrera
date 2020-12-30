class AccountsController < ApplicationController
  def new
  end

  def create_callback
    google_identity = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
    user = User.new(name: google_identity.name, email_address: google_identity.email_address,
                    avatar_url: google_identity.avatar_url)
    if user.save
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al crear el usuario"
      redirect_to root_path
    end
  end

  def edit
  end

  def update_callback
    if session[:user_id]
      session[:user_id] = nil
      redirect_to root_path
    else
      login = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
      user = User.find_by(email_address: login.email_address)
      if user
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash[:error] = "Ocurrió un error al iniciar sesión"
        redirect_to root_path
      end
    end
  end
end
