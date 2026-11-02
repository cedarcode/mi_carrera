module Users
  class PasskeysController < Devise::PasskeysController
    include Devise::Reauthenticatable

    prepend_before_action :ensure_feature_enabled!
    before_action :require_reauthentication!, only: %i[index create destroy]

    def index; end

    private

    def reauthentication_return_path
      user_passkeys_path
    end

    def after_update_path
      user_passkeys_path
    end

    def ensure_feature_enabled!
      redirect_to root_path if ENV['ENABLE_PASSKEYS'].blank?
    end
  end
end
