require 'rails_helper'

# Cloudflare terminates the connection, so the client IP only survives in
# X-Forwarded-For, which kamal-proxy preserves via `forward_headers: true`.
RSpec.describe 'Client IP resolution behind Cloudflare', type: :request do
  let(:cloudflare_edge_ip) { '173.245.48.1' } # inside 173.245.48.0/20
  let(:client_ip) { '201.217.57.10' }

  # Returns the request object the controller saw, for attributes like remote_ip that
  # only exist once the middleware stack has run.
  def request_seen_by_controller
    seen = nil
    subscriber = ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |*, payload|
      seen = payload[:request]
    end

    yield

    seen
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  def request_via_cloudflare
    subject_record = create(:subject, :with_exam)

    request_seen_by_controller do
      get subject_url(subject_record), env: {
        'REMOTE_ADDR' => cloudflare_edge_ip,
        'HTTP_X_FORWARDED_FOR' => "#{client_ip}, #{cloudflare_edge_ip}"
      }
    end
  end

  it 'resolves remote_ip to the client IP instead of the Cloudflare edge IP' do
    expect(request_via_cloudflare.remote_ip).to eq(client_ip)
  end
end
