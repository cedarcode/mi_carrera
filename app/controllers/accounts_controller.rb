class AccountsController < ApplicationController
  def new
  end

  def create_callback
    login = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
    user = User.new(name: login.name, email_address: login.email_address, avatar_url: login.avatar_url)
    if user.save
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al crear el usuario"
      redirect_to root_path
    end
  end
end
