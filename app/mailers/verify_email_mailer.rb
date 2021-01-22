class VerifyEmailMailer < ApplicationMailer
  default from: 'Student <student@student.com>'

  def verify(user)
    @user = user

    mail to: @user.email_address, subject: 'Verificar Email'
  end
end
