require 'rails_helper'

RSpec.describe 'Rate limiting', type: :request do
  # Test env uses :null_store and RateLimiting binds its store at declaration time, so the
  # counter can only be driven by stubbing it.
  it 'answers 429 only once a client exceeds a budget of 20 requests' do
    allow(ActionController::Base.cache_store).to receive(:increment).and_return(20)
    get subject_url(create(:subject, :with_exam))
    expect(response).to have_http_status(:ok)

    allow(ActionController::Base.cache_store).to receive(:increment).and_return(21)
    get subject_url(create(:subject, :with_exam))
    expect(response).to have_http_status(:too_many_requests)
  end
end
