require 'rails_helper'

RSpec.describe 'Computacion 2025 warning', type: :system do
  let(:warning_text) { 'El plan de Computación 2025 está en proceso de implementación' }

  context 'when user has computacion 2025 plan' do
    let(:user) { create(:user) }

    before { sign_in user }

    it 'shows warning on home page' do
      visit root_path

      expect(page).to have_text(warning_text)
    end

    it 'shows warning on planner page' do
      visit subject_plans_path

      expect(page).to have_text(warning_text)
    end
  end

  context 'when user has a different plan' do
    let(:other_degree_plan) { create(:degree_plan, name: '2025') }
    let(:user) { create(:user, degree_plan: other_degree_plan) }

    before { sign_in user }

    it 'does not show warning on home page' do
      visit root_path

      expect(page).not_to have_text(warning_text)
    end
  end
end
