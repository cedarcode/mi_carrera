class EmailVerificationsMailer < ApplicationMailer
  default from: 'Student <student@student.com>'

  def verify(user)
    @user = user

    mail to: @user.email_address, subject: 'Verificar correo electrónico'
  end
end
