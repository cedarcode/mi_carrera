module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def new
      super do
        @get_passkey_options = WebAuthn::Credential.options_for_get(user_verification: 'required')
        session[:authentication_challenge] = @get_passkey_options.challenge
      end
    end
  end
end
