require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe 'PUT #update' do
    context 'regular user' do
      let(:regular_user) { create :user, password: 'secret' }

      before do
        sign_in regular_user
      end

      it 'update email keeps provider and uid as nil' do
        put user_registration_path, params: {
          user: {
            email: 'newemail@gmail.com',
            current_password: 'secret'
          }
        }

        expect(regular_user.reload.email).to eq 'newemail@gmail.com'
        expect(regular_user.provider).to be_nil
        expect(regular_user.uid).to be_nil
      end

      it 'update email redirects to root_path after update' do
        put user_registration_path, params: {
          user: {
            email: 'newemail@gmail.com',
            current_password: 'secret'
          }
        }

        expect(response).to redirect_to(root_path)
      end

      it 'requires current password' do
        put user_registration_path, params: {
          user: {
            email: 'newemail@gmail.com'
          }
        }

        expect(response).to have_http_status(:success)
        expect(path).to eq user_registration_path
      end
    end

    context 'oauth user' do
      let(:oauth_user) { create :user, provider: 'google_oauth2', uid: '123456', password: 'secret' }

      before do
        sign_in oauth_user
      end

      it 'update email removes provider and uid' do
        patch user_registration_path, params: {
          user: {
            email: 'newemail@gmail.com',
            current_password: 'secret'
          }
        }

        expect(oauth_user.reload.email).to eq 'newemail@gmail.com'
        expect(oauth_user.provider).to be_nil
        expect(oauth_user.uid).to be_nil
      end

      it 'update email redirects to root_path' do
        patch user_registration_path, params: {
          user: {
            email: 'newemail@gmail.com',
            current_password: 'secret'
          }
        }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    it 'creates user with approvals when session has approvals' do
      degree = create :degree, name: "computacion"
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

      expect(user.approvals).to eq [subject1.course.id, subject2.exam.id, subject2.course.id]
      expect(user.degree).to eq(degree)
    end
  end
end
