class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters_sign_up, only: [:create]
  before_action :configure_permitted_parameters_account_update, only: [:update]

  private

  def update_resource(resource, params)
    if resource.provider == 'google_oauth2'

      if resource.email != params[:email]
        params[:uid] = nil
        params[:provider] = nil
      end

      if params[:password].present? || params[:password_confirmation].present?
        resource.update_with_password(params)
      else
        params.delete('current_password')
        resource.update_without_password(params)
      end

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
