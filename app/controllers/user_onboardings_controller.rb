class UserOnboardingsController < ApplicationController
  def update
    banner_type = params[:banner_type]

    case banner_type
    when 'planner'
      current_student.planner_banner_mark_as_viewed!
    when 'welcome'
      current_student.welcome_banner_mark_as_viewed!
    else
      render json: { error: 'Invalid banner type' }, status: :bad_request
      return
    end

    head :ok
  end
end
