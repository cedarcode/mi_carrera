require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "user can't sign up due to password not meeting length criteria" do
    get new_account_path
    assert_response :success

    post account_path, params: {
      email: 'alice@test.com',
      password: 'a123',
      password_confirmation: 'a123'
    }

    assert_response :redirect
    assert_redirected_to new_account_path
  end
end
