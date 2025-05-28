require 'rails_helper'
require 'support/checkboxes_spec_helper'

RSpec.describe "Subject", type: :system do
  include CheckboxesSpecHelper

  let(:gal1) { create(:subject, :with_exam, name: 'GAL 1', credits: 9, code: '1030') }
  let(:gal2) { create(:subject, :with_exam, name: 'GAL 2', credits: 10, code: '1031') }

  before do
    create(:subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course)

    create(:and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:enrollment_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ])
  end

  it "lists entrollment prerequisites correctly" do
    visit subject_path(gal2)

    expect(page).to have_content("Todos los siguientes")

    find('a', text: 'Todos los siguientes').click

    expect(page).to have_content("Estar inscripto a curso de #{gal1.code} - #{gal1.name}")
  end

  it 'can search for subjects' do
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

  context "when logged in" do
    before do
      sign_in create(:user)
    end

    it "can review subjects" do
      visit subject_path(gal1)

      expect(page).to have_text('Sin calificar')
      click_button('star_outline', match: :first)

      expect(page).to have_text('Puntuación: 5.0')

      review = Review.last
      aggregate_failures do
        expect(review.subject).to eq(gal1)
        expect(review.user).to eq(User.last)
        expect(review.rating).to eq(5)
      end

      # Update review to 4 stars
      all('button', text: 'star')[1].click

      expect(page).to have_text('Puntuación: 4.0')

      review = Review.last
      aggregate_failures do
        expect(review.subject).to eq(gal1)
        expect(review.user).to eq(User.last)
        expect(review.rating).to eq(4)
      end

      # Destroy review by clicking on the same star
      all('button', text: 'star')[1].click

      expect(page).to have_text('Sin calificar')

      expect(Review.count).to eq(0)
    end
  end
end
