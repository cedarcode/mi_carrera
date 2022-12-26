class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters_sign_up, only: [:create]
  before_action :configure_permitted_parameters_account_update, only: [:update]

  private

  def update_resource(resource, params)
    if resource.provider == 'google_oauth2'
      # if email changed delete uid and provider

      if resource.email != params[:email]
        params[:uid] = nil
        params[:provider] = nil
      end

      params.delete('current_password')
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def configure_permitted_parameters_sign_up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :email, :password, :password_confirmation])
  end

  def configure_permitted_parameters_account_update
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :full_name,
        :email,
        :password,
        :password_confirmation,
        :current_password
      ]
    )
  end
end
