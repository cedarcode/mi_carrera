require 'rails_helper'

RSpec.describe UserOnboardingsController, type: :request do
  describe 'PATCH #update' do
    context 'when signed in' do
      let(:user) { create(:user) }

      before { sign_in user }

      context 'with valid banner type "welcome"' do
        it 'marks welcome banner as viewed and returns ok' do
          patch user_onboardings_path, params: { banner_type: 'welcome', format: :json }

          expect(response).to have_http_status(:ok)
          expect(user.reload.welcome_banner_viewed).to be true
        end
      end

      context 'with valid banner type "planner"' do
        it 'marks planner banner as viewed and returns ok' do
          patch user_onboardings_path, params: { banner_type: 'planner', format: :json }

          expect(response).to have_http_status(:ok)
          expect(user.reload.planner_banner_viewed).to be true
        end
      end

      context 'with invalid banner type' do
        it 'raises unknown attribute error' do
          expect {
            patch user_onboardings_path, params: { banner_type: 'invalid', format: :json }
          }.to raise_error(ActiveModel::UnknownAttributeError)
        end
      end
    end

    context 'when not signed in' do
      context 'with valid banner type "welcome"' do
        it 'updates cookie and returns ok' do
          patch user_onboardings_path, params: { banner_type: 'welcome', format: :json }

          expect(response).to have_http_status(:ok)
        end
      end

      context 'with valid banner type "planner"' do
        it 'raises invalid banner type error' do
          expect {
            patch user_onboardings_path, params: { banner_type: 'planner', format: :json }
          }.to raise_error(RuntimeError, 'Invalid banner type: planner')
        end
      end

      context 'with invalid banner type' do
        it 'raises invalid banner type error' do
          expect {
            patch user_onboardings_path, params: { banner_type: 'invalid', format: :json }
          }.to raise_error(RuntimeError, 'Invalid banner type: invalid')
        end
      end
    end
  end
end
