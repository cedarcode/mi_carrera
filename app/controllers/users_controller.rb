class UsersController < ApplicationController
  def email_verification
    user = User.find_by(id: params[:id])
    if user.update(verified: true)
      sign_in(user.id)
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al verificar tu correo electrónico"
      redirect_to root_path
    end
  end
end
