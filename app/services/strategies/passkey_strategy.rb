module Strategies
  class PasskeyStrategy < Warden::Strategies::Base
    def valid?
      params[:passkey_public_key].present?
    end

    def authenticate!
      webauthn_passkey = WebAuthn::Credential.from_get(JSON.parse(params[:passkey_public_key]))
      passkey = Passkey.find_by(external_id: webauthn_passkey.id)
      unless passkey
        self.fail(:passkey_not_found)
        return
      end

      begin
        webauthn_passkey.verify(
          session[:authentication_challenge],
          public_key: passkey.public_key,
          sign_count: passkey.sign_count,
          user_verification: true
        )
      rescue WebAuthn::Error
        self.fail(:invalid_passkey)
        return
      end
      passkey.update!(sign_count: webauthn_passkey.sign_count)

      success!(passkey.user)
    ensure
      session.delete(:authentication_challenge)
    end
  end
end
