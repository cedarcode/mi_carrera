module Users
  class PasskeysController < Devise::PasskeysController
    prepend_before_action :ensure_feature_enabled!

    def index; end

    private

    def after_update_path
      user_passkeys_path
    end

    def ensure_feature_enabled!
      redirect_to root_path if ENV['ENABLE_PASSKEYS'].blank?
    end
  end
end
