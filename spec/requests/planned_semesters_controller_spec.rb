require 'rails_helper'

RSpec.describe PlannedSemestersController, type: :request do
  let(:user) { create(:user, planned_semesters: 2) }

  before { sign_in user }

  describe 'POST /planned_semesters' do
    it 'increments planned_semesters by 1 and returns turbo stream' do
      expect {
        post planned_semesters_path, params: { format: :turbo_stream }
      }.to change { user.reload.planned_semesters }.by(1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Semestre #{user.planned_semesters}")
    end
  end
end
