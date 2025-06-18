require 'rails_helper'

RSpec.describe CurrentOptionalSubjectsController, type: :request do
  describe 'GET #index' do
    it 'returns http success' do
      get current_optional_subjects_url
      expect(response).to have_http_status(:success)
    end
  end
end
