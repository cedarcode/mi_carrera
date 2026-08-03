# Cloudflare terminates the connection, so requests reach us from a Cloudflare
# PoP, not the client. Rate limiting keys on request.remote_ip
# (ActionController::RateLimiting), which ActionDispatch::RemoteIp resolves by
# walking X-Forwarded-For and skipping IPs in config.action_dispatch.trusted_proxies.
# Without the Cloudflare ranges here, the edge IP is treated as the client, so
# every visitor behind the same PoP shares one rate-limit bucket.
#
# Ranges from https://www.cloudflare.com/ips-v4/ and https://www.cloudflare.com/ips-v6/,
# fetched 2026-08-03. Cloudflare rarely changes these; re-fetch if requests from a new
# Cloudflare PoP start getting rate-limited together unexpectedly.
CLOUDFLARE_IP_RANGES = %w[
  173.245.48.0/20
  103.21.244.0/22
  103.22.200.0/22
  103.31.4.0/22
  141.101.64.0/18
  108.162.192.0/18
  190.93.240.0/20
  188.114.96.0/20
  197.234.240.0/22
  198.41.128.0/17
  162.158.0.0/15
  104.16.0.0/13
  104.24.0.0/14
  172.64.0.0/13
  131.0.72.0/22
  2400:cb00::/32
  2606:4700::/32
  2803:f800::/32
  2405:b500::/32
  2405:8100::/32
  2a06:98c0::/29
  2c0f:f248::/32
].map { |range| IPAddr.new(range) }.freeze

Rails.application.config.action_dispatch.trusted_proxies =
  ActionDispatch::RemoteIp::TRUSTED_PROXIES + CLOUDFLARE_IP_RANGES
