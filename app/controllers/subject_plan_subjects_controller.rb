class SubjectPlanSubjectsController < ApplicationController
  include SubjectsHelper

  def index
    json = not_planned_subjects.group_by(&:category).map do |category, subjects|
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

  def not_planned_subjects
    TreePreloader
      .preload(
        current_degree
          .subjects
          .where.not(id: current_user.planned_subjects)
          .ordered_by_category
          .ordered_by_short_or_full_name
      )
      .reject { |subject| current_student.approved?(subject) }
  end
end
