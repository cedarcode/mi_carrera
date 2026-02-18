require 'rails_helper'
require 'support/checkboxes_helper'

RSpec.describe 'Changing degrees', type: :system do
  include CheckboxesHelper

  let!(:computacion_degree) { degrees(:computacion) }
  let!(:computacion_degree_plan) { degree_plans(:computacion_active_plan) }
  let!(:sistemas_degree) do
    create(:degree, id: 'sistemas', name: 'Ingeniería en Sistemas', current_plan: '2025')
  end
  let!(:sistemas_degree_plan) do
    create(:degree_plan, degree: sistemas_degree, name: '2025', active: true)
  end
  let!(:user) { create(:user) }

  before do
    sign_in user
  end

  context 'when feature is enabled' do
    before do
      allow(Features::ChangingDegrees).to receive(:enabled?).and_return(true)
    end

    it 'allows user to change their degree plan successfully' do
      visit root_path

      within('header') do
        expect(page).to have_text('Ingeniería en Computación')
      end

      expect(user.reload.degree_plan).to eq(computacion_degree_plan)

      click_user_menu
      click_on 'Cambiar Carrera'

      expect(page).to have_text('Cambiar Carrera')
      expect(page).to have_select('degree_id', selected: 'Ingeniería en Computación')

      select 'Ingeniería en Sistemas', from: 'degree_id'

      select '2025', from: 'degree_plan_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu plan ha sido actualizado correctamente.')
      expect(current_path).to eq(root_path)

      within('header') do
        expect(page).to have_text('Ingeniería en Sistemas')
      end

      expect(user.reload.degree_plan).to eq(sistemas_degree_plan)
    end
  end

  context 'when feature is disabled' do
    before do
      allow(Features::ChangingDegrees).to receive(:enabled?).and_return(false)
    end

    it 'does not show the change degree link in user menu' do
      visit root_path

      within('header') do
        expect(page).not_to have_text('Ingeniería en Computación')
        expect(page).not_to have_text('Ingeniería en Sistemas')
      end

      click_user_menu

      expect(page).not_to have_link('Cambiar Carrera')
    end

    it 'redirects to root path when trying to access edit page directly' do
      visit edit_user_degrees_path

      expect(current_path).to eq(root_path)
    end
  end

  context 'when cookie student' do
    let!(:computacion_subject) { create(:subject, name: 'Algebra', degree_plan: computacion_degree_plan) }
    let!(:sistemas_subject) { create(:subject, name: 'Programacion', degree_plan: sistemas_degree_plan) }

    before do
      sign_out :user
      allow(Features::ChangingDegrees).to receive(:enabled?).and_return(true)
    end

    it 'shows default degree on edit page when no cookie is set' do
      visit edit_user_degrees_path

      expect(page).to have_text('Cambiar Carrera')
      expect(page).to have_select('degree_id', selected: 'Ingeniería en Computación')
    end

    it 'allows selecting degree plan when no cookie is set' do
      visit root_path

      within('header') do
        expect(page).to have_text('Ingeniería en Computación')
      end

      click_user_menu
      click_on 'Cambiar Carrera'

      select 'Ingeniería en Sistemas', from: 'degree_id'

      select '2025', from: 'degree_plan_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu plan ha sido actualizado correctamente.')
      expect(current_path).to eq(root_path)

      within('header') do
        expect(page).to have_text('Ingeniería en Sistemas')
      end

      degree_plan_cookie = page.driver.browser.manage.cookie_named('degree_plan_id')
      expect(degree_plan_cookie[:value]).to eq(sistemas_degree_plan.id.to_s)

      expect(page).to have_text('Programacion')
      expect(page).not_to have_text('Algebra')
    end

    it 'allows changing degree plan and updates the cookie' do
      visit root_path
      page.driver.browser.manage.add_cookie(name: 'degree_plan_id', value: computacion_degree_plan.id.to_s)

      visit root_path
      click_user_menu
      click_on 'Cambiar Carrera'

      select 'Ingeniería en Sistemas', from: 'degree_id'

      select '2025', from: 'degree_plan_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu plan ha sido actualizado correctamente.')
      expect(current_path).to eq(root_path)

      degree_plan_cookie = page.driver.browser.manage.cookie_named('degree_plan_id')
      expect(degree_plan_cookie[:value]).to eq(sistemas_degree_plan.id.to_s)
    end

    it 'shows subjects for new degree plan after changing' do
      visit root_path
      page.driver.browser.manage.add_cookie(name: 'degree_plan_id', value: computacion_degree_plan.id.to_s)

      visit root_path

      within('header') do
        expect(page).to have_text('Ingeniería en Computación')
      end

      expect(page).to have_text('Algebra')
      expect(page).not_to have_text('Programacion')

      click_user_menu
      click_on 'Cambiar Carrera'

      select 'Ingeniería en Sistemas', from: 'degree_id'

      select '2025', from: 'degree_plan_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu plan ha sido actualizado correctamente.')
      expect(current_path).to eq(root_path)

      within('header') do
        expect(page).to have_text('Ingeniería en Sistemas')
      end

      expect(page).not_to have_text('Algebra')
      expect(page).to have_text('Programacion')
    end

    it 'persists new degree plan after adding approvables' do
      visit root_path
      page.driver.browser.manage.add_cookie(name: 'degree_plan_id', value: computacion_degree_plan.id.to_s)

      visit root_path

      within('header') do
        expect(page).to have_text('Ingeniería en Computación')
      end

      click_user_menu
      click_on 'Cambiar Carrera'

      select 'Ingeniería en Sistemas', from: 'degree_id'

      select '2025', from: 'degree_plan_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu plan ha sido actualizado correctamente.')
      expect(current_path).to eq(root_path)

      within('header') do
        expect(page).to have_text('Ingeniería en Sistemas')
      end

      expect(page).to have_text('Programacion')

      check_approvable(sistemas_subject.course)

      degree_plan_cookie = page.driver.browser.manage.cookie_named('degree_plan_id')
      expect(degree_plan_cookie[:value]).to eq(sistemas_degree_plan.id.to_s)
    end

    it 'persists degree plan across page refreshes' do
      visit root_path
      page.driver.browser.manage.add_cookie(name: 'degree_plan_id', value: computacion_degree_plan.id.to_s)

      visit root_path

      within('header') do
        expect(page).to have_text('Ingeniería en Computación')
      end

      click_user_menu
      click_on 'Cambiar Carrera'

      select 'Ingeniería en Sistemas', from: 'degree_id'

      select '2025', from: 'degree_plan_id'
      click_on 'Guardar'

      expect(page).to have_text('Tu plan ha sido actualizado correctamente.')
      expect(current_path).to eq(root_path)

      within('header') do
        expect(page).to have_text('Ingeniería en Sistemas')
      end

      expect(page).to have_text('Programacion')

      visit root_path

      within('header') do
        expect(page).to have_text('Ingeniería en Sistemas')
      end

      expect(page).to have_text('Programacion')
      expect(page).not_to have_text('Algebra')

      degree_plan_cookie = page.driver.browser.manage.cookie_named('degree_plan_id')
      expect(degree_plan_cookie[:value]).to eq(sistemas_degree_plan.id.to_s)
    end
  end

  private

  def click_user_menu
    find("#user-menu[data-controller-connected='true']").click
  end
end
