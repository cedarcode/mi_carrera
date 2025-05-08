require "application_controller_test_case"

class RegistrationsControllerTest < ApplicationControllerTestCase
  setup do
    @oauth_user = create :user, provider: 'google_oauth2', uid: '123456', password: 'secret'
    @regular_user = create :user, password: 'secret'
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

  test 'create a user with approvals in session should create user with approvals' do
    subject1 = create :subject, name: "Subject 1", credits: 16
    subject2 = create :subject, :with_exam, name: "Subject 2", credits: 16
    post approvable_approval_path(subject1.course), params: {
      subject: {
        course_approved: 'yes'
      },
      format: 'turbo_stream'
    }
    post approvable_approval_path(subject2.exam), params: {
      subject: {
        exam_approved: 'yes'
      },
      format: 'turbo_stream'
    }
    post user_registration_path, params: {
      user: {
        email: 'newuser@gmail.com',
        password: 'secret',
        password_confirmation: 'secret'
      }
    }
    user = User.where(email: 'newuser@gmail.com').first

    assert_equal [subject1.course.id, subject2.exam.id, subject2.course.id], user.approvals
  end
end
