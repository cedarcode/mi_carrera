require "application_system_test_case"

class SubjectsTest < ApplicationSystemTestCase
  test "can search for subjects" do
    gal1 = create :subject, :with_exam, name: "GAL 1", credits: 9, code: "1030"
    create :subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course

    gal2 = create :subject, :with_exam, name: "GAL 2", credits: 10, code: "1031"
    create :and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ]

    create :subject, name: "Taller 1", short_name: 'T1', credits: 11, code: "1040"

    visit all_subjects_path

    assert_text "GAL 1"
    assert_text "GAL 2"
    assert_text "T1"

    click_search_trigger
    fill_in 'search', with: "Taller\n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_text "T1"

    fill_in 'search', with: " Taller\n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_text "T1"

    fill_in 'search', with: "Taller \n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_text "T1"

    fill_in 'search', with: "T1\n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_text "T1"

    fill_in 'search', with: "1030\n"

    assert_text "GAL 1"
    assert_no_text "GAL 2"
    assert_no_text "T1"

    fill_in 'search', with: "103\n"

    assert_text "GAL 1"
    assert_text "GAL 2"
    assert_no_text "T1"

    fill_in 'search', with: "This subject does not exist\n"

    assert_no_text "GAL 1"
    assert_no_text "GAL 2"
    assert_no_text "T1"
    assert_text "No hay resultados"

    fill_in 'search', with: " \n"

    assert_text "GAL 1"
    assert_text "GAL 2"
    assert_text "T1"
  end

  test "can review subjects" do
    subject = create :subject
    user = create :user

    # Not logged
    visit subject_path(subject)

    assert_text "Sin calificar"
    click_button("star_outline", match: :first)
    assert_current_path new_user_session_path

    # Logged
    fill_in "Correo electrónico", with: user.email
    fill_in "Contraseña", with: "secret"
    click_button "Ingresar"

    visit subject_path(subject)

    # Create a 5-star review
    all('button', text: 'star')[0].click
    Review.last.tap do |review|
      assert_equal(subject, review.subject)
      assert_equal(user, review.user)
      assert_equal(5, review.rating)
    end

    # Update review to 4 stars
    all('button', text: 'star')[1].click
    Review.last.tap do |review|
      assert_equal(subject, review.subject)
      assert_equal(user, review.user)
      assert_equal(4, review.rating)
    end

    # Destroy review by clicking on the same star
    all('button', text: 'star')[1].click
    assert_equal(0, Review.count)
  end
end
