require 'rails_helper'
require 'support/controller_request_helper'

# Cloudflare terminates the connection, so the client IP only survives in
# X-Forwarded-For, which kamal-proxy preserves via `forward_headers: true`.
RSpec.describe 'Client IP resolution behind Cloudflare', type: :request do
  include ControllerRequestHelper

  let(:cloudflare_edge_ip) { '173.245.48.1' } # inside 173.245.48.0/20
  let(:client_ip) { '201.217.57.10' }

  before do
    allow(CloudflareRails::Importer).to receive(:cloudflare_ips).and_return([IPAddr.new('173.245.48.0/20')])
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

  # What ActionController::RateLimiting keys its cache on.
  it 'resolves remote_ip to the client IP instead of the Cloudflare edge IP' do
    expect(request_via_cloudflare.remote_ip).to eq(client_ip)
  end

  # Rack resolves this separately, so trusted_proxies alone would not fix it.
  it 'resolves ip to the client IP instead of the Cloudflare edge IP' do
    expect(request_via_cloudflare.ip).to eq(client_ip)
  end
end
