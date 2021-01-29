ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_group(code: nil, name: "Subject " + rand(1000))
    if !code
      code = name.parameterize
    end
    group = SubjectGroup.where(code: code).first_or_create
    group.update!(name: name)
    group
  end

  def create_subject(
    code: nil,
    name: "Subject " + rand(1000),
    credits: 5,
    exam: true,
    group: create_group(name: "Matemática")
  )
    if !code
      code = name.parameterize
    end
    subject = Subject.create!(code: code, name: name, credits: credits, group_id: group.id)
    subject.create_course!

    if exam
      subject.create_exam!
    end

    subject
  end

  def create_user(email: "bob@test.com", name: nil)
    User.create!(email_address: email, password: "bob123", name: name, verified: true)
  end

  def wait_for_async_request
    # Ideally we would really wait for the request to complete instead of
    # sleeping a fixed amount of time
    sleep 1
  end
end
