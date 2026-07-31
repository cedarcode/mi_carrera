require 'rails_helper'

RSpec.describe 'Rate limiting', type: :request do
  # Test env uses :null_store and RateLimiting binds its store at declaration time, so the
  # counter can only be driven by stubbing it. Well above any budget we would configure.
  before do
    allow(ActionController::Base.cache_store).to receive(:increment).and_return(1_000_000)
  end

  it 'answers 429 once a client exceeds its budget' do
    get subject_url(create(:subject, :with_exam))

    expect(response).to have_http_status(:too_many_requests)
  end
end
