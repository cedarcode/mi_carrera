ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def create_group(name)
    SubjectGroup.where(name: name).first_or_create
  end

  def create_subject(code: "A code", name: "A subject", credits: 5, exam: true)
    group = create_group("Matemática")
    subject = Subject.create!(code: code, name: name, credits: credits, group_id: group.id)
    subject.create_course!

    if exam
      subject.create_exam!
    end

    subject
  end

  def wait_for_async_request
    # Ideally we would really wait for the request to complete instead of
    # sleeping a fixed amount of time
    sleep 1
  end
end
