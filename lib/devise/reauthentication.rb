# frozen_string_literal: true

module Devise
  # Records that a user proved themselves recently, and answers whether that
  # proof is still valid.
  #
  # This module knows nothing about how the user proved themselves. Include it
  # in your own challenge controller and call +grant_reauthentication!+ once
  # you have verified whatever proof you asked for.
  module Reauthentication
    def reauthenticated?
      stamped_at = warden.session(resource_name)["reauthenticated_at"]

      stamped_at.present? && Time.zone.at(stamped_at) > Devise.reauthentication_period.ago
    end

    def grant_reauthentication!
      warden.session(resource_name)["reauthenticated_at"] = Time.now.to_i
    end
  end
end
