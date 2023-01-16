ActionMailer::Base.smtp_settings = {
  address: "smtp.sendgrid.net",
  port: 587,
  user_name: 'apikey',
  password: ENV['SENDGRID_API_KEY']
}
