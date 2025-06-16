class UserOnboardingsController < ApplicationController
  def update
    current_student.welcome_banner_mark_as_viewed!

    head :ok
  end
end
