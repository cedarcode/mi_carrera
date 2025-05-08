require 'rails_helper'
require 'support/application_system_spec_helper'

RSpec.describe 'Approvals', type: :system do
  include ActionView::RecordIdentifier
  include ApplicationSystemSpecHelper

  it 'can check and uncheck approvables from index and show page' do
    gal1 = create(:subject, :with_exam, name: 'GAL 1', credits: 9, code: '1030')
    create(:subject_prerequisite, approvable: gal1.exam, approvable_needed: gal1.course)

    gal2 = create(:subject, :with_exam, name: 'GAL 2', credits: 10)
    create(:and_prerequisite, approvable: gal2.course, operands_prerequisites: [
      create(:subject_prerequisite, approvable_needed: gal1.course),
      create(:subject_prerequisite, approvable_needed: gal1.exam),
    ])

    taller = create(:subject, name: 'Taller', credits: 11)

    visit root_path

    expect(page).to have_text('GAL 1')
    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('Taller')
    expect(page).to have_text('0 créditos')

    assert_approvable_checkbox(gal1.course, checked: false, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: true)

    check_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: false)
    expect(page).to have_text('0 créditos')

    uncheck_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: false, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: true)
    expect(page).to have_text('0 créditos')

    check_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: false)
    expect(page).to have_text('0 créditos')

    click_on 'GAL 1'

    expect(page).to have_text('Curso aprobado?')
    expect(page).to have_text('Examen aprobado?')
    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: false)

    check_approvable(gal1.exam)

    assert_approvable_checkbox(gal1.course, checked: true, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: true, disabled: false)

    uncheck_approvable(gal1.course)

    assert_approvable_checkbox(gal1.course, checked: false, disabled: false)
    assert_approvable_checkbox(gal1.exam, checked: false, disabled: true)

    check_approvable(gal1.course)
    check_approvable(gal1.exam)

    visit root_path

    expect(page).to have_text('GAL 1')
    expect(page).to have_text('GAL 2')
    expect(page).to have_text('Taller')
    expect(page).to have_text('9 créditos')

    uncheck_approvable(gal1.course)

    expect(page).not_to have_text('GAL 2')
    expect(page).to have_text('0 créditos')

    check_approvable(taller.course)

    expect(page).to have_text('11 créditos')

    visit all_subjects_path

    click_on 'GAL 2'

    assert_approvable_checkbox(gal2.course, checked: false, disabled: true)
    assert_approvable_checkbox(gal2.exam, checked: false, disabled: false)

    find('.mdc-deprecated-list-item', text: 'Todos los siguientes').click

    expect(page).to have_text('1030 - GAL 1 (curso)')
    expect(page).to have_text('1030 - GAL 1 (examen)')

    click_on '1030 - GAL 1 (examen)'

    expect(current_path).to eq(subject_path(gal1))
  end
end
