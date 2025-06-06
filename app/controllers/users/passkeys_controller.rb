module Users
  class PasskeysController < ApplicationController
    def index
      @create_passkey_options = WebAuthn::Credential.options_for_create(
        user: {
          id: current_user.webauthn_id,
          name: current_user.email.split('@').first
        },
        exclude: current_user.passkeys.pluck(:external_id),
        authenticator_selection: { user_verification: "required" }
      )
      session[:current_registration_challenge] = { challenge: @create_passkey_options.challenge }
    end

    def create
      webauthn_passkey = WebAuthn::Credential.from_create(JSON.parse(params[:passkey_public_key]))

      begin
        webauthn_passkey.verify(session[:current_registration_challenge]["challenge"], user_verification: true)

        passkey = current_user.passkeys.find_or_initialize_by(
          external_id: Base64.strict_encode64(webauthn_passkey.raw_id)
        )

        if passkey.update(
          name: params[:name],
          public_key: webauthn_passkey.public_key,
          sign_count: webauthn_passkey.sign_count
        )
          render json: { status: "ok" }, status: :ok
          flash[:notice] = "Tu passkey ha sido agregada correctamente."
        else
          render json: "Couldn't add your Security Key", status: :unprocessable_entity
        end
      rescue WebAuthn::Error => e
        render json: "Verification failed: #{e.message}", status: :unprocessable_entity
      ensure
        session.delete(:current_registration_challenge)
      end
    end

    def destroy
      current_user.passkeys.destroy(params[:id])

      redirect_to user_passkeys_path
      flash[:notice] = "Tu passkey ha sido eliminada correctamente."
    end
  end
end
