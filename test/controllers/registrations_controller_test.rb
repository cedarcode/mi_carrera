require "application_controller_test_case"

class RegistrationsControllerTest < ApplicationControllerTestCase
  setup do
    @oauth_user = create_user(email: 'oauth@gmail.com', password: 'secret', provider: 'google_oauth2', uid: '123456')
    @regular_user = create_user(email: 'user1@gmail.com', password: 'secret')
  end

  test 'update email of regular user should maintain provider and uid as nil' do
    sign_in @regular_user
    put user_registration_path, params: {
      user: {
        email: 'newemail@gmail.com',
        current_password: 'secret'
      }
    }

    assert_equal @regular_user.reload.email, 'newemail@gmail.com'
    assert_nil @regular_user.reload.provider
    assert_nil @regular_user.reload.uid
  end

  test 'update email of regular user should return http success' do
    sign_in @regular_user
    put user_registration_path, params: {
      user: {
        email: 'newemail@gmail.com',
        current_password: 'secret'
      }
    }

    assert_redirected_to root_path
  end

  test 'when updating user, current password is always required' do
    sign_in @regular_user
    put user_registration_path, params: {
      user: {
        email: 'newemail@gmail.com'
      }
    }

    assert_response :success
    assert_equal user_registration_path, path
  end

  test 'update email of oauth user should remove provider and uid' do
    sign_in @oauth_user
    patch user_registration_path, params: {
      user: {
        email: 'newemail@gmail.com',
        current_password: 'secret'
      }
    }

    assert_equal @oauth_user.reload.email, 'newemail@gmail.com'
    assert_nil @oauth_user.reload.provider
    assert_nil @oauth_user.reload.uid
  end

  test 'update email of oauth user should redirect to root_path' do
    sign_in @oauth_user
    patch user_registration_path, params: {
      user: {
        email: 'newemail@gmail.com',
        current_password: 'secret'
      }
    }
    assert_redirected_to root_path
  end
end
