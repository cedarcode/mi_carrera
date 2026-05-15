module Planner
  class NotPlannedSubjectsController < ApplicationController
    include SubjectsHelper

    before_action :authenticate_user!

    def index
      json = not_planned_subjects.group_by(&:category).map do |category, subjects|
        {
          label: formatted_category(category),
          id: category,
          choices: subjects.map do |subject|
            {
              label: display_name(subject),
              value: subject.id,
            }
          end
        }
      end

      render json:
    end

    private

    def not_planned_subjects
      TreePreloader
        .preload(
          current_degree_plan
            .subjects
            .where.not(id: current_user.planned_subjects)
            .active_or_approved(current_student.approved_approvable_ids)
            .ordered_by_category
            .ordered_by_short_or_full_name
        )
    end
  end
end
