require "application_controller_test_case"

class CurrentOptionalSubjectsControllerTest < ApplicationControllerTestCase
  test 'should get index' do
    get current_optional_subjects_url
    assert_response :success
  end
end
