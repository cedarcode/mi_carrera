require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  let(:oauth_user) { create :user, provider: 'google_oauth2', uid: '123456789' }

  before do
    OmniAuth.config.test_mode = true
  end

  describe "POST #google_oauth2" do
    it "redirects to root_path if user exists" do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: oauth_user.email
        }
      )

      post user_google_oauth2_omniauth_callback_path
      expect(response).to redirect_to(root_path)
    end

    it "updates the user if user exists" do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '555555555',
        info: {
          email: oauth_user.email
        }
      )

      expect {
        post user_google_oauth2_omniauth_callback_path
      }.not_to change(User, :count)

      expect(oauth_user.reload.uid).to eq "555555555"
    end

    it "creates a new user if user doesn't exist" do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: "345678901",
        info: {
          email: 'new@gmail.com'
        }
      )

      expect {
        post user_google_oauth2_omniauth_callback_path
      }.to change(User, :count).by(1)
    end

    it 'create user with approvals if there are approvals in session' do
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

      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: "345678901",
        info: {
          email: 'new@gmail.com'
        }
      )

      post user_google_oauth2_omniauth_callback_path

      user = User.where(email: 'new@gmail.com').first
      expect(user.approvals).to eq [subject1.course.id, subject2.exam.id, subject2.course.id]
    end
  end
end
