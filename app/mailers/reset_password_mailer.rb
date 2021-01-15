class ResetPasswordMailer < ApplicationMailer
  default from: 'Student <student@student.com>'

  def forgot_password(user)
    @user = user

    mail to: user.email_address, subject: 'Reset password instructions'
  end
end
