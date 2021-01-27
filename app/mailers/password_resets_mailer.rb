class PasswordResetsMailer < ApplicationMailer
  default from: 'Student <student@student.com>'

  def password_reset(user)
    @user = user

    mail to: @user.email_address, subject: 'Restablecer contraseña'
  end
end
