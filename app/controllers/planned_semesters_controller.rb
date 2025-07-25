class PlannedSemestersController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.update!(planned_semesters: current_user.planned_semesters + 1)

    @semester = current_user.planned_semesters
  end
end
