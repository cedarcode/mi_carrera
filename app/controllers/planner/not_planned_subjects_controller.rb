module Planner
  class NotPlannedSubjectsController < ApplicationController
    include SubjectsHelper

    before_action :authenticate_user!

    def index
      json = not_planned_and_not_approved_subjects.group_by(&:category).map do |category, subjects|
        {
          label: formatted_category(category),
          id: category,
          choices: subjects.map do |subject|
            {
              label: display_planned_subject_name_and_code(subject),
              value: subject.id,
            }
          end
        }
      end

      render json:
    end

    private

    def not_planned_and_not_approved_subjects
      TreePreloader
        .preload(
          current_degree
            .subjects
            .where.not(id: current_user.planned_subjects)
            .where.not(id: current_student.approved_subjects)
            .ordered_by_category
            .ordered_by_short_or_full_name
        )
    end
  end
end
