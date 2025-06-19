WebAuthn.configure do |config|
  # This value needs to match `window.location.origin` evaluated by
  # the User Agent during registration and authentication ceremonies.
  # Multiple origins can be used when needed. Using more than one will imply you MUST configure rp_id explicitely.
  # If you need your credentials to be bound to a single origin but you have more than one tenant, please see
  # [our Advanced Configuration section](https://github.com/cedarcode/webauthn-ruby/blob/master/docs/advanced_configuration.md)
  # instead of adding multiple origins.
  config.allowed_origins = Rails.configuration.webauthn_origin
  config.rp_id = Rails.configuration.webauthn_rp_id

  # Relying Party name for display purposes
  config.rp_name = "Mi Carrera"

  # Optionally configure a client timeout hint, in milliseconds.
  # This hint specifies how long the browser should wait for any
  # interaction with the user.
  # This hint may be overridden by the browser.
  # https://www.w3.org/TR/webauthn/#dom-publickeycredentialcreationoptions-timeout
  # config.credential_options_timeout = 120_000

  # You can optionally specify a different Relying Party ID
  # (https://www.w3.org/TR/webauthn/#relying-party-identifier)
  # if it differs from the default one.
  #
  # In this case the default would be "auth.example.com", but you can set it to
  # the suffix "example.com"
  #
  # config.rp_id = "example.com"

  # Configure preferred binary-to-text encoding scheme. This should match the encoding scheme
  # used in your client-side (user agent) code before sending the credential to the server.
  # Supported values: `:base64url` (default), `:base64` or `false` to disable all encoding.
  #
  # config.encoding = :base64url

  # Possible values: "ES256", "ES384", "ES512", "PS256", "PS384", "PS512", "RS256", "RS384", "RS512", "RS1"
  # Default: ["ES256", "PS256", "RS256"]
  #
  # config.algorithms << "ES384"
end
