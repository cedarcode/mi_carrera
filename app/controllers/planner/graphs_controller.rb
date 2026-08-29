module Planner
  class GraphsController < ApplicationController
    before_action :authenticate_user!

    def show
      subject_plans = current_user.subject_plans
                                  .includes(subject: [:course, :exam])

      @semester_map = subject_plans.to_h do |subject_plan|
        [subject_plan.subject_id, subject_plan.semester]
      end

      @subjects = subject_plans.map(&:subject)
      TreePreloader.preload(@subjects)
    end
  end
end
