# frozen_string_literal: true

# DeviseWebauthn Configuration
DeviseWebauthn.configure do |config|
  # ==> Model Configuration

  # The user model (default: "User")
  # config.user_model_name = "User"

  # ==> Relying Party Configuration
  # Relying party name for WebAuthn - displayed to users during authentication
  config.relying_party_name = "MiCarrera"

  # Relying party identifier - should be your domain (default: nil, auto-detected)
  # For development: "localhost", for production: "yourdomain.com"
  # config.relying_party_id = Rails.env.development? ? "localhost" : "yourdomain.com"

  # Relying party origins - array of allowed origins (default: [], auto-detected)
  # config.relying_party_origins = Rails.env.development? ? ["http://localhost:3000"] : ["https://yourdomain.com"]

  # ==> WebAuthn Options
  # User verification requirement (default: "required")
  # Options: "required", "preferred", "discouraged"
  # config.user_verification = "required"

  # Timeout for WebAuthn operations in milliseconds (default: 60_000)
  # config.timeout = 60_000

  # ==> Authenticator Selection Criteria
  # Configure which types of authenticators are preferred
  # config.authenticator_selection = {
  #   resident_key: "required",        # "required", "preferred", "discouraged"
  #   user_verification: "required"    # "required", "preferred", "discouraged"
  # }

  # ==> Cryptographic Algorithms
  # Supported signing algorithms (default: ["ES256", "PS256", "RS256"])
  # config.algorithms = %w[ES256 PS256 RS256]

  # ==> Backward Compatibility
  # Single origin support (deprecated, use relying_party_origins instead)
  # config.relying_party_origin = "http://localhost:3000"
end
