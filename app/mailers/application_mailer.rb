class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.sendgrid[:from_email_address]
  layout 'mailer'
end
