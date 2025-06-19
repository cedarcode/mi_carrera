require 'rails_helper'

RSpec.describe "Subject", type: :system do
  let(:gal1) { create(:subject, :with_exam, name: 'GAL 1', credits: 9, code: '1030', degree: degrees(:computacion)) }
  let(:gal2) { create(:subject, :with_exam, name: 'GAL 2', credits: 10, code: '1031', degree: degrees(:computacion)) }

  before do
    create(:subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course)

    create(:and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:enrollment_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ])
  end

  it "lists entrollment prerequisites correctly" do
    visit subject_path(gal1)

    expect(page).to have_content("GAL 1")

    within('label', text: 'Curso aprobado?') do
      checkbox = find('input[type="checkbox"]')
      expect(checkbox).to_not be_checked
    end

    within_exam_prerequisites do
      expect(page).to_not have_content("done")
    end

    within('label', text: 'Curso aprobado?') do
      checkbox = find('input[type="checkbox"]')
      checkbox.click

      expect(checkbox).to be_checked
    end

    within_exam_prerequisites do
      expect(page).to have_content("done")
    end

    visit subject_path(gal2)

    expect(page).to have_content("GAL 2")

    within_course_prerequisites do
      find('a', text: 'Todos los siguientes').click
    end

    expect(page).to have_content("Estar inscripto a curso de #{gal1.code} - #{gal1.name}")
  end

  it 'can search for subjects' do
    create(:subject, name: 'Taller 1', short_name: 'T1', credits: 11, code: '1040', degree: degrees(:computacion))

    visit all_subjects_path

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).to have_text('T1')

    click_on "search"

    fill_in 'search', with: "Taller\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: " Taller\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: "Taller \n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: "T1\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: "1030\n"

    expect(page).to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).not_to have_text('T1')

    fill_in 'search', with: "103\n"

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).not_to have_text('T1')

    fill_in 'search', with: "This subject does not exist\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).not_to have_text('T1')
    expect(page).to have_text('No hay resultados')

    fill_in 'search', with: " \n"

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).to have_text('T1')

    user = create(:user, degree: degrees(:computacion))

    visit new_user_session_path

    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    click_on 'Ingresar'
    expect(page).to have_text('Iniciaste sesión correctamente')

    visit all_subjects_path

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).to have_text('T1')

    click_on "search"

    fill_in 'search', with: "Taller\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: " Taller\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: "Taller \n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: "T1\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('T1')

    fill_in 'search', with: "1030\n"

    expect(page).to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).not_to have_text('T1')

    fill_in 'search', with: "103\n"

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).not_to have_text('T1')

    fill_in 'search', with: "This subject does not exist\n"

    expect(page).not_to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).not_to have_text('T1')
    expect(page).to have_text('No hay resultados')

    fill_in 'search', with: " \n"

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).to have_text('T1')
  end

  it "can review subjects" do
    user = create(:user, degree: degrees(:computacion))

    visit subject_path(gal1)

    expect(page).to have_text('-.-')
    click_button('star_outline', match: :first)
    expect(page).to have_text('Iniciar sesión')

    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: user.password
    click_button "Ingresar"
    expect(page).to have_text('Iniciaste sesión correctamente.')

    visit subject_path(gal1)

    expect(page).to have_text('-.-')
    click_button('star_outline', match: :first)
    expect(page).to have_text('5.0')

    # Update review to 4 stars
    all('button', text: 'star')[1].click

    expect(page).to have_text('4.0')

    # Destroy review by clicking on the same star
    all('button', text: 'star')[1].click

    expect(page).to have_text('-.-')
  end

  private

  def within_course_prerequisites(&block)
    within(:xpath, "//span[text()='Del curso:']/following-sibling::*[1]", &block)
  end

  def within_exam_prerequisites(&block)
    within(:xpath, "//span[text()='Del examen:']/following-sibling::*[1]", &block)
  end
end
