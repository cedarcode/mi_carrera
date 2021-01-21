class VerifyEmailMailer < ApplicationMailer
  default from: 'Student <student@student.com>'

  def verify(email)
    mail to: email, subject: 'Verificar Email'
  end
end
