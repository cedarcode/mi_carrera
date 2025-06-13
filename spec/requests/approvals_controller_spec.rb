require 'rails_helper'
require 'support/cookies_helper'

RSpec.describe ApprovalsController, type: :request do
  include ActiveSupport::Testing::TimeHelpers
  include CookiesHelper

  describe 'POST #create' do
    context 'when not logged in' do
      it 'stores approval in cookie' do
        subject1 = create :subject, :with_exam
        subject2 = create :subject

        post approvable_approval_path(subject1.course, subject_show: true), params: { format: 'turbo_stream' }
        post approvable_approval_path(subject1.exam, subject_show: true), params: { format: 'turbo_stream' }
        post approvable_approval_path(subject2.course, subject_show: true), params: { format: 'turbo_stream' }

        expect(approvable_ids_in_cookie(cookies)).to eq [subject1.course.id, subject1.exam.id, subject2.course.id]
      end

      it 'sets cookie expiration to 20 years' do
        travel_to Time.zone.local(2020, 1, 1, 0, 0, 0) do
          subject1 = create :subject, :with_exam
          post approvable_approval_path(subject1.course, subject_show: true), params: { format: 'turbo_stream' }

          expect(cookies.get_cookie('approved_approvable_ids').expires.to_date).to eq 20.years.from_now.to_date
        end
      end
    end
  end
end
