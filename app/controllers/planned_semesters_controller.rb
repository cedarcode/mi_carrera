class PlannedSemestersController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.update!(planned_semesters: current_user.planned_semesters + 1)
    redirect_to subject_plans_path
  end
end 