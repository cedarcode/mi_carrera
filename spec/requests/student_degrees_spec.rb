require 'rails_helper'

RSpec.describe "StudentDegrees", type: :request do
  describe "PATCH /student_degrees" do
    let(:student) { build(:cookie_student) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_student).and_return(student)
    end

    it 'calls change_degree with the correct param and redirects' do
      expect(student).to receive(:change_degree).with('electrica')
      patch student_degrees_path, params: { degree: 'electrica' }
      expect(response).to redirect_to(root_path)
    end
  end
end
