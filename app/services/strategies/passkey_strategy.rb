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

      begin
        webauthn_passkey.verify(
          session[:creation_challenge],
          public_key: passkey.public_key,
          sign_count: passkey.sign_count,
          user_verification: true
        )
      rescue WebAuthn::SignCountVerificationError
        return fail!("Fallo el sign count verification")
      rescue WebAuthn::Error
        return fail!("Fallo la verificación del passkey")
      end

      passkey.update!(sign_count: webauthn_passkey.sign_count)

      success!(passkey.user)
    rescue WebAuthn::Error => e
      self.fail("Passkey verification error and it raised exception: #{e.message}")
    ensure
      session.delete(:creation_challenge)
    end
  end
end
