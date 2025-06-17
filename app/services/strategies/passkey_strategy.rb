module Strategies
  class PasskeyStrategy < Warden::Strategies::Base
    def valid?
      params[:passkey_public_key].present?
    end

    def authenticate!
      webauthn_passkey = WebAuthn::Credential.from_get(JSON.parse(params[:passkey_public_key]))
      passkey = Passkey.find_by(external_id: webauthn_passkey.id)
      unless passkey
        self.fail(:invalid)
        return
      end

      begin
        webauthn_passkey.verify(
          session[:current_authentication]['challenge'],
          public_key: passkey.public_key,
          sign_count: passkey.sign_count,
          user_verification: true
        )
        passkey.update!(sign_count: webauthn_passkey.sign_count)

        success!(passkey.user)
      ensure
        session.delete(:current_authentication)
      end
    end
  end
end
