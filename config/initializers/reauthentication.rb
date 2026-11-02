# frozen_string_literal: true

# The setting and the Warden hook live here, not under `lib/`, because Zeitwerk
# only loads a file when Ruby resolves a constant defined in it. Calling
# `Devise.reauthentication_period` resolves no constant, and the hook defines
# no constant at all.
module Devise
  # How long a re-authentication grant stays valid. The window slides forward
  # on every gated request.
  mattr_accessor :reauthentication_period
  @@reauthentication_period = 15.minutes
end

# Signing in counts as proof, so a user who has just signed in is never
# interrupted. This runs for every strategy, whatever it checks.
Warden::Manager.after_authentication do |_record, warden, options|
  warden.session(options[:scope])["reauthenticated_at"] = Time.now.to_i
end
