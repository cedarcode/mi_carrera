# frozen_string_literal: true

module Devise
  # Interrupts a request when the user has not proved themselves recently.
  #
  # Each controller picks the actions it wants to gate:
  #
  #   include Devise::Reauthenticatable
  #   before_action :require_reauthentication!, only: %i[index create destroy]
  module Reauthenticatable
    extend ActiveSupport::Concern
    include Devise::Reauthentication

    private

    def require_reauthentication!
      if reauthenticated?
        grant_reauthentication! # slide the window
        return
      end

      store_location_for(resource_name, reauthentication_return_path)
      redirect_to new_user_reauthentication_path
    end

    def reauthentication_return_path
      request.fullpath if request.get? || request.head?
    end
  end
end
