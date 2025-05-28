require 'rails_helper'
require 'support/checkboxes_spec_helper'

RSpec.describe "Subject", type: :system do
  include CheckboxesSpecHelper

  it "lists entrollment prerequisites correctly" do
    subject = create :subject
    other_subject = create :subject, :with_exam, short_name: "Other Subject"
    create :and_prerequisite, approvable: subject.course, operands_prerequisites: [
      create(:enrollment_prerequisite, approvable_needed: other_subject.exam)
    ]

    visit subject_path(subject)

    expect(page).to have_content("Todos los siguientes")

    find('a', text: 'Todos los siguientes').click

    expect(page).to have_content("Estar inscripto a examen de #{other_subject.code} - Other Subject")
  end

  it 'can search for subjects' do
    gal1 = create(:subject, :with_exam, name: 'GAL 1', credits: 9, code: '1030')
    create(:subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course)

    gal2 = create(:subject, :with_exam, name: 'GAL 2', credits: 10, code: '1031')
    create(:and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ])

    create(:subject, name: 'Taller 1', short_name: 'T1', credits: 11, code: '1040')

    visit all_subjects_path

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).to have_text('T1')

    click_search_trigger
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

  it 'can review subjects' do
    subject = create(:subject)
    user = create(:user)

    # Not logged
    visit subject_path(subject)

    expect(page).to have_text('Sin calificar')
    click_button('star_outline', match: :first)

    # Logged
    fill_in 'Correo electrónico', with: user.email
    fill_in 'Contraseña', with: user.password
    click_button 'Ingresar'

    expect(page).to have_text('Iniciaste sesión correctamente')
    visit subject_path(subject)

    expect(page).to have_text('Sin calificar')

    # Create a 5-star review
    all('button', text: 'star')[0].click

    expect(page).to have_text('Puntuación: 5.0')

    review = Review.last
    aggregate_failures do
      expect(review.subject).to eq(subject)
      expect(review.user).to eq(user)
      expect(review.rating).to eq(5)
    end

    # Update review to 4 stars
    all('button', text: 'star')[1].click

    expect(page).to have_text('Puntuación: 4.0')

    review = Review.last
    aggregate_failures do
      expect(review.subject).to eq(subject)
      expect(review.user).to eq(user)
      expect(review.rating).to eq(4)
    end

    # Destroy review by clicking on the same star
    all('button', text: 'star')[1].click

    expect(page).to have_text('Sin calificar')

    expect(Review.count).to eq(0)
  end
end
