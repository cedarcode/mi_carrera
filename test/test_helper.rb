ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_group(code: nil, name: "Subject #{rand(1000)}")
    if !code
      code = name.parameterize
    end
    group = SubjectGroup.where(code: code).first_or_create
    group.update!(name: name)
    group
  end

  def create_subject(
    code: nil,
    name: "Subject #{rand(1000)}",
    credits: 5,
    exam: true,
    group: create_group(name: "Matemática"),
    semester: 1
  )
    if !code
      code = name.parameterize
    end
    subject = Subject.create!(code: code, name: name, credits: credits, group_id: group.id, semester: semester)
    subject.create_course!

    if exam
      subject.create_exam!
    end

    subject
  end

  def create_user(email: "bob#{rand(1000)}@test.com", password: "bob123", provider: nil, uid: nil, approvals: nil)
    User.create!(email: email, password: password, provider: provider, uid: uid, approvals:)
  end

  def wait_for_approvables_reloaded
    assert page.has_no_selector?('.foreground-layer')
  end

  def within_actions_menu
    within '.mdc-drawer__content' do
      yield
    end
  end

  def click_actions_menu
    find(".mdc-icon-button", text: 'menu').click
  end
end
