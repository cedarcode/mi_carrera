require 'rails_helper'

RSpec.describe SubjectsController, type: :request do
  describe 'GET #show' do
    it 'returns http success for a subject in the current degree plan' do
      subject = create(:subject, :with_exam)

      get subject_url(subject)

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include("Esta materia pertenece a")
    end

    it 'returns http success for a subject from a different degree plan' do
      other_degree_plan = create(:degree_plan)
      subject = create(:subject, :with_exam, degree_plan_id: other_degree_plan.id)

      get subject_url(subject)

      expect(response).to have_http_status(:success)
    end

    it 'shows a warning with full plan names when the subject is from a different degree plan' do
      other_degree_plan = create(:degree_plan)
      subject = create(:subject, :with_exam, degree_plan_id: other_degree_plan.id)

      get subject_url(subject)

      expect(response.body).to include("Esta materia pertenece a")
      expect(response.body).to include(other_degree_plan.display_name)
    end

    it 'disables checkboxes when the subject is from a different degree plan' do
      other_degree_plan = create(:degree_plan)
      subject = create(:subject, :with_exam, degree_plan_id: other_degree_plan.id)

      get subject_url(subject)

      expect(response.body).to include('disabled="disabled"')
    end
  end
end
