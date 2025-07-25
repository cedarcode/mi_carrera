module Strategies
  class PasskeyStrategy < Warden::Strategies::Base
    def valid?
      params[:passkey_public_key].present?
    end

    def authenticate!
      webauthn_passkey = WebAuthn::Credential.from_get(JSON.parse(params[:passkey_public_key]))
      passkey = Passkey.find_by(external_id: webauthn_passkey.id)
      unless passkey
        self.fail("Passkey not found")
        return
      end

      webauthn_passkey.verify(
        session[:creation_challenge],
        public_key: passkey.public_key,
        sign_count: passkey.sign_count,
        user_verification: true
      )
      if webauthn_passkey.error
        self.fail("Passkey verification failed and an error was kept: #{webauthn_passkey.error}")
        return
      end

      if webauthn_passkey.sign_count == nil
        self.fail("Passkey sign count is missing")
        return
      end

      if passkey.update!(sign_count: webauthn_passkey.sign_count)
        self.fail("Passkey verification failed")
        return
      end

      success!(passkey.user)
    rescue WebAuthn::Error => e
      self.fail("Passkey verification error and it raised exception: #{e.message}")
    ensure
      session.delete(:creation_challenge)
    end
  end
end
