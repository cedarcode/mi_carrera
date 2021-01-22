class VerifyEmailMailer < ApplicationMailer
  default from: 'Student <student@student.com>'

  def verify(user)
    mail to: user.email_address, subject: 'Verificar Email'
  end
end
