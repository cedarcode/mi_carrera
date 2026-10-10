# frozen_string_literal: true

module Devise
  # Asks a signed-in user to prove themselves again, and writes a grant once
  # they do.
  #
  # The proof it checks on its own is the password, so it depends on
  # `database_authenticatable`. Add another kind of proof by overriding
  # `proof_verified?` and calling `super` to keep the password working.
  class ReauthenticationsController < DeviseController
    include Devise::Reauthentication

    before_action :authenticate_scope!

    def new; end

    def create
      if proof_verified?
        grant_reauthentication!
        redirect_to stored_location_for(resource_name) || after_reauthentication_path
      else
        set_flash_message! :alert, :reauthentication_failed, scope: :"devise.failure"
        # Do not read the stored location here. Reading it deletes it, and the
        # user's retry would then lose its destination.
        redirect_to url_for(action: :new)
      end
    end

    private

    def proof_verified?
      password.present? && verify_password
    end

    # Going through `valid_for_authentication?` rather than straight to
    # `valid_password?` keeps `lockable` counting, so this page is not a way
    # around `config.maximum_attempts`.
    def verify_password
      resource.valid_for_authentication? { resource.valid_password?(password) }
    end

    def password
      params.dig(resource_name, :password)
    end

    # The default url to be used after a passed challenge, when nothing was
    # stored. You can overwrite this method in your own
    # ReauthenticationsController.
    def after_reauthentication_path
      signed_in_root_path(resource)
    end

    def authenticate_scope!
      send(:"authenticate_#{resource_name}!", force: true)
      self.resource = send(:"current_#{resource_name}")
    end
  end
end
