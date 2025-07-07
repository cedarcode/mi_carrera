class PlannedSemestersController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.update!(planned_semesters: current_user.planned_semesters + 1)

    @not_planned_approved_subjects, @not_planned_subjects =
      TreePreloader.preload(Subject.ordered_by_category.ordered_by_short_or_full_name).reject { |subject|
        current_user.planned?(subject)
      }.partition { |subject| current_student.approved?(subject) }
    @semester = current_user.planned_semesters
  end
end
