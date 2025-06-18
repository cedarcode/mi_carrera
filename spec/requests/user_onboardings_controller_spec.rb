require 'rails_helper'

RSpec.describe UserOnboardingsController, type: :request do
  describe 'PATCH #update' do
    context 'when signed in' do
      it 'returns http ok' do
        sign_in create(:user)

        patch user_onboardings_path, params: { format: :json }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not signed in' do
      it 'returns http ok' do
        patch user_onboardings_path, params: { format: :json }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
