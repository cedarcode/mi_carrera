Rails.application.configure do
  Dotenv.load

  config.google_sign_in.client_id = ENV['GOOGLE_SIGN_IN_CLIENT_ID']
  config.google_sign_in.client_secret = ENV['GOOGLE_SIGN_IN_CLIENT_SECRET']
end
