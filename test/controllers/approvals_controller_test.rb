require "application_controller_test_case"

class ApprovalsControllerTest < ApplicationControllerTestCase
  test "when not logged in, when adding approval, should store it in the cookie" do
    subject1 = create :subject, :with_exam
    subject2 = create :subject

    post approvable_approval_path(subject1.course, subject_show: true), params: { format: 'turbo_stream' }
    post approvable_approval_path(subject1.exam, subject_show: true), params: { format: 'turbo_stream' }
    post approvable_approval_path(subject2.course, subject_show: true), params: { format: 'turbo_stream' }

    assert_equal [subject1.course.id, subject1.exam.id, subject2.course.id].to_json,
                 cookies.get_cookie('approved_approvable_ids').value
  end

  test "when not logged in, when adding approval, the cookie should expire in 20 years" do
    subject1 = create :subject, :with_exam
    post approvable_approval_path(subject1.course, subject_show: true), params: { format: 'turbo_stream' }

    assert_equal 20.years.from_now.to_date, cookies.get_cookie('approved_approvable_ids').expires.to_date
  end
end
