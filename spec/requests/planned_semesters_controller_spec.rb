require 'rails_helper'

RSpec.describe PlannedSemestersController, type: :request do
  let(:user) { create(:user, planned_semesters: 2) }

  before { sign_in user }

  describe 'POST /planned_semesters' do
    it 'increments planned_semesters by 1 and redirects' do
      expect {
        post planned_semesters_path
      }.to change { user.reload.planned_semesters }.by(1)
      expect(response).to redirect_to(subject_plans_path)
    end
  end
end 