require 'rails_helper'

RSpec.describe SubjectGroupsController, type: :request do
  describe 'GET #show' do
    it 'returns http success for a subject group in the current degree plan' do
      subject_group = create(:subject_group)
      cookies[:degree_plan_id] = subject_group.degree_plan_id.to_s

      get subject_group_url(subject_group)

      expect(response).to have_http_status(:success)
    end

    it 'returns 404 for a non-existent subject group id' do
      get "/grupos/999999999"

      expect(response).to have_http_status(:not_found)
    end

    it 'returns a routing 404 for a non-numeric id and does not reach the controller' do
      get "/grupos/choices.js"

      expect(response).to have_http_status(:not_found)
    end
  end
end
