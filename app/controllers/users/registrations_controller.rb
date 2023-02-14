class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters_sign_up, only: [:create]
  before_action :configure_permitted_parameters_account_update, only: [:update]

  def create
    super do |user|
      if user.persisted?
        user.approvals = JSON.parse(cookies[:approved_approvable_ids] || "[]")
        user.welcome_banner_viewed = cookies[:welcome_banner_viewed] == "true"
      end
    end
  end

  private

  def update_resource(resource, params)
    if resource.provider == 'google_oauth2' && resource.email != params[:email]
      params[:uid] = nil
      params[:provider] = nil
    end

    resource.update_with_password(params)
  end

  def configure_permitted_parameters_sign_up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end

  def configure_permitted_parameters_account_update
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :email,
        :password,
        :password_confirmation,
        :current_password
      ]
    )
  end
end
