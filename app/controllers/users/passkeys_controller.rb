module Users
  class PasskeysController < Devise::PasskeysController
    prepend_before_action :ensure_feature_enabled!

    def index
      @create_passkey_options = WebAuthn::Credential.options_for_create(
        user: {
          id: current_user.webauthn_id,
          name: current_user.email
        },
        exclude: current_user.passkeys.pluck(:external_id),
        authenticator_selection: {
          resident_key: 'required',
          user_verification: 'required'
        }
      )
      session[:creation_challenge] = @create_passkey_options.challenge
    end

    private

    def after_update_path
      user_passkeys_path
    end

    def ensure_feature_enabled!
      redirect_to root_path if ENV['ENABLE_PASSKEYS'].blank?
    end
  end
end
