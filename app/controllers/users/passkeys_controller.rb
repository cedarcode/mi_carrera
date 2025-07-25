module Users
  class PasskeysController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_feature_enabled!

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

    def create
      webauthn_passkey = WebAuthn::Credential.from_create(JSON.parse(params[:passkey_public_key]))

      begin
        webauthn_passkey.verify(session[:creation_challenge], user_verification: true)

        if current_user.passkeys.create(
          external_id: webauthn_passkey.id,
          name: params[:name],
          public_key: webauthn_passkey.public_key,
          sign_count: webauthn_passkey.sign_count
        )
          redirect_to user_passkeys_path, notice: "Tu passkey ha sido agregada correctamente."
        else
          redirect_to user_passkeys_path, alert: "Hubo un error agregando esta passkey."
        end
      rescue WebAuthn::Error
        render json: "Verification failed", status: :unprocessable_entity
      ensure
        session.delete(:creation_challenge)
      end
    end

    def destroy
      if current_user.passkeys.destroy(params[:id])
        redirect_to user_passkeys_path, notice: "Tu passkey ha sido eliminada correctamente."
      else
        redirect_to user_passkeys_path, alert: "Hubo un error eliminando esta passkey."
      end
    end

    private

    def ensure_feature_enabled!
      redirect_to root_path if ENV['ENABLE_PASSKEYS'].blank?
    end
  end
end
