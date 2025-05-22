require 'rails_helper'

RSpec.describe "Subject", type: :system do
  it "lists entrollment prerequisites correctly" do
    degree = create :degree, name: "Ing. comp", key: "computacion"
    ActsAsTenant.current_tenant = degree

    subject = create :subject
    other_subject = create :subject, :with_exam, short_name: "Other Subject"
    create :and_prerequisite, approvable: subject.course, operands_prerequisites: [
      create(:enrollment_prerequisite, approvable_needed: other_subject.exam)
    ]

    visit root_path
    expect(page).to have_content("Ing. comp")
    click_on 'Seleccionar'
    expect(page).to have_current_path(root_path)

    visit subject_path(subject)

    expect(page).to have_content("Todos los siguientes")

    find('a', text: 'Todos los siguientes').click

    expect(page).to have_content("Estar inscripto a examen de #{other_subject.code} - Other Subject")
  end
end
