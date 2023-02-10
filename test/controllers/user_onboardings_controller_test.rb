require "application_controller_test_case"

class UserOnboardingsControllerTest < ApplicationControllerTestCase
  setup do
    @user = create :user
  end

  test 'patch update should return ok when signed in' do
    sign_in @user

    patch user_onboardings_path, params: { format: :json }

    assert_response :ok
  end

  test 'patch update should return ok when not signed in' do
    patch user_onboardings_path, params: { format: :json }

    assert_response :ok
  end
end
