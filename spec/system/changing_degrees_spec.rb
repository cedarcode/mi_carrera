require 'rails_helper'

RSpec.describe 'Changing degrees', type: :system do
  let!(:computacion_degree) { degrees(:computacion) }
  let!(:sistemas_degree) { create(:degree, id: 'sistemas', current_plan: '2025', include_inco_subjects: false) }
  let!(:user) { create(:user, degree: computacion_degree) }

  before do
    sign_in user
  end

  context 'when feature is enabled' do
    before do
      ENV['ENABLE_CHANGING_DEGREES'] = 'true'
    end

    after do
      ENV.delete('ENABLE_CHANGING_DEGREES')
    end

    it 'allows user to change their degree successfully' do
      visit root_path

      click_user_menu
      click_on 'Cambiar Carrera'

      expect(page).to have_text('Cambiar Carrera')
      expect(page).to have_select('degree_id', selected: 'Computacion')

      select 'Sistemas', from: 'degree_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu carrera ha sido actualizada correctamente.')
      expect(page).to have_select('degree_id', selected: 'Sistemas')

      user.reload
      expect(user.degree_id).to eq('sistemas')
    end

    it 'redirects back to edit page after successful update' do
      visit edit_user_degree_path(user)

      select 'Sistemas', from: 'degree_id'
      click_on 'Guardar'

      expect(current_path).to eq(edit_user_degree_path(user))
    end
  end

  context 'when feature is disabled' do
    before do
      ENV.delete('ENABLE_CHANGING_DEGREES')
    end

    it 'does not show the change degree link in user menu' do
      visit root_path

      click_user_menu

      expect(page).not_to have_link('Cambiar Carrera')
    end

    it 'redirects to root path when trying to access edit page directly' do
      visit edit_user_degree_path(user)

      expect(current_path).to eq(root_path)
    end
  end

  context 'when user is not authenticated' do
    before do
      ENV['ENABLE_CHANGING_DEGREES'] = 'true'
      sign_out :user
    end

    after do
      ENV.delete('ENABLE_CHANGING_DEGREES')
    end

    it 'redirects to login page when accessing edit page' do
      visit edit_user_degree_path(user)

      expect(current_path).to eq(new_user_session_path)
    end
  end

  private

  def click_user_menu
    find("#user-menu[data-controller-connected='true']").click
  end
end
