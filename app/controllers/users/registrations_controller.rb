class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters_sign_up, only: [:create]
  before_action :configure_permitted_parameters_account_update, only: [:update]

  def create
    super do |user|
      if user.persisted?
        user.approvals = JSON.parse(cookies[:approved_approvable_ids] || "[]")
        user.welcome_banner_viewed = cookies[:welcome_banner_viewed] == "true"
        user.degree_id = cookies[:degree_id] if cookies[:degree_id].present?

        # TODO: stop persisting degree_id on the user and only set degree plan
        if cookies[:degree_plan_id].present?
          user.degree_plan_id = cookies[:degree_plan_id]
        else
          degree = Degree.find_by(id: user.degree_id) if user.degree_id.present?
          degree ||= Degree.default
          user.degree_plan_id ||= degree.active_degree_plan.id
        end

        user.save!
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
