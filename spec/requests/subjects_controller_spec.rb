require 'rails_helper'

RSpec.describe SubjectsController, type: :request do
  describe 'GET #show' do
    it 'returns http success for a subject in the current degree plan' do
      subject = create(:subject, :with_exam)

      get subject_url(subject)

      expect(response).to have_http_status(:success)
    end

    it 'returns http success for a subject from a different degree plan' do
      other_degree_plan = create(:degree_plan)
      subject = create(:subject, :with_exam, degree_plan_id: other_degree_plan.id)

      get subject_url(subject)

      expect(response).to have_http_status(:success)
    end
  end
end
