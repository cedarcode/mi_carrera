class PlannedSemestersController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.update!(planned_semesters: current_user.planned_semesters + 1)

    @not_planned_subjects =
      TreePreloader.preload(Subject.ordered_by_category.ordered_by_short_or_full_name).reject do |subject|
        current_user.planned?(subject) || current_student.approved?(subject)
      end

    @semester = current_user.planned_semesters
  end
end
