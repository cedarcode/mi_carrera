module Planner
  class GraphsController < ApplicationController
    before_action :authenticate_user!

    def show
      planned_subjects = current_user.subject_plans
        .includes(subject: [:course, :exam])
        .map(&:subject)

      TreePreloader.preload(planned_subjects)

      @subjects = planned_subjects
    end
  end
end
