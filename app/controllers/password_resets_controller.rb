class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email])

    if user
      user.generate_password_reset_token
      user.save!

      PasswordResetsMailer.password_reset(user).deliver
    end

    redirect_to root_path, notice: "Se envió un correo electrónico a #{params[:email]}"
  end
end
