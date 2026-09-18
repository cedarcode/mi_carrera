require 'rails_helper'

RSpec.describe 'Unknown request formats', type: :request do
  # show_exceptions off makes the escape visible: without the rescue_from these raise
  # instead of answering, which is exactly what AppSignal reports.
  around do |example|
    original = Rails.application.env_config['action_dispatch.show_exceptions']
    Rails.application.env_config['action_dispatch.show_exceptions'] = :none
    example.run
  ensure
    Rails.application.env_config['action_dispatch.show_exceptions'] = original
  end

  it 'answers 406 instead of raising when a client only accepts JSON' do
    get root_url, headers: { 'Accept' => 'application/json' }

    expect(response).to have_http_status(:not_acceptable)
  end

  it 'still answers HTML to a regular browser request' do
    get root_url, headers: { 'Accept' => 'text/html' }

    expect(response).to have_http_status(:ok)
  end
end
