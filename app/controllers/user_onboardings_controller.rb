class UserOnboardingsController < ApplicationController
  def update
    current_student.mark_banner_as_viewed!(params[:banner_type])
    head :ok
  end
end
