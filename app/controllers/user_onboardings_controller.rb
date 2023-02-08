class UserOnboardingsController < ApplicationController
  def update
    current_student.welcome_banner_mark_as_viewed!

    respond_to do |format|
      format.json { render json: { status: :ok } }
    end
  end
end
