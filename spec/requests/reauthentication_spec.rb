require 'rails_helper'

RSpec.describe 'Re-authentication', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:password) { 'S3cr3tP@ssw0rd!' }
  let(:user) { create(:user, password:) }
  ENV['ENABLE_PASSKEYS'] = 'true'

  describe 'GET #new' do
    context 'when the user is signed out' do
      it 'redirects to the sign-in page' do
        get new_user_reauthentication_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is signed in' do
      before do
        sign_in user
      end

      it 'asks for the password' do
        get new_user_reauthentication_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Verifica tu identidad')
        expect(response.body).to include('Contraseña')
      end
    end
  end

  describe 'POST #create' do
    context 'when the user is signed out' do
      it 'redirects to the sign-in page' do
        post user_reauthentication_path, params: { user: { password: password } }

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is signed in' do
      before do
        sign_in user
        get root_path
      end

      context 'when the right password is provided' do
        context 'when there is a stored location to redirect to afterwards' do
          before do
            travel Devise.reauthentication_period + 1.minute
            get user_passkeys_path
          end

          it 'writes a grant and redirects to the saved location' do
            post user_reauthentication_path, params: { user: { password: password } }

            expect(response).to redirect_to(user_passkeys_path)

            # Further requests inside the reauthentication period don't
            # require re-authentication
            get user_passkeys_path
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when the gate caught a passkey creation' do
          before do
            travel Devise.reauthentication_period + 1.minute
            post user_passkeys_path, params: { name: 'A new passkey' }
          end

          it 'writes a grant and redirects back to the passkeys page' do
            post user_reauthentication_path, params: { user: { password: password } }

            expect(response).to redirect_to(user_passkeys_path)

            # Further requests inside the reauthentication period don't
            # require re-authentication
            get user_passkeys_path
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when the user reached the challenge page on their own' do
          it 'writes a grant and falls back to the Devise layer default' do
            post user_reauthentication_path, params: { user: { password: password } }

            expect(response).to redirect_to(root_path)
          end
        end

        context 'when the gate caught a passkey deletion' do
          let(:passkey) do
            user.passkeys.create!(external_id: 'external-id', name: 'A passkey', public_key: 'key', sign_count: 0)
          end

          before do
            path = user_passkey_path(passkey)
            travel Devise.reauthentication_period + 1.minute
            delete path
          end

          it 'writes a grant and redirects back to the passkeys page' do
            post user_reauthentication_path, params: { user: { password: password } }

            expect(response).to redirect_to(user_passkeys_path)
          end
        end
      end

      context 'with the wrong password' do
        context 'when there is a stored location to redirect to afterwards' do
          before do
            travel Devise.reauthentication_period + 1.minute
            get user_passkeys_path
          end

          it 'fails and keeps the saved location' do
            post user_reauthentication_path, params: { user: { password: 'not the password' } }

            expect(response).to redirect_to(new_user_reauthentication_path)
            expect(flash[:alert]).to eq I18n.t('devise.failure.reauthentication_failed')

            # The retry still knows where the user was headed.
            post user_reauthentication_path, params: { user: { password: password } }

            expect(response).to redirect_to(user_passkeys_path)
          end

          it 'counts against the lockout' do
            expect do
              post user_reauthentication_path, params: { user: { password: 'not the password' } }
            end.to change { user.reload.failed_attempts }.by(1)
          end

          it 'locks the account once the attempts run out' do
            user.update!(failed_attempts: Devise.maximum_attempts - 1)

            post user_reauthentication_path, params: { user: { password: 'not the password' } }

            expect(user.reload).to be_access_locked
          end
        end
      end
    end
  end
end
