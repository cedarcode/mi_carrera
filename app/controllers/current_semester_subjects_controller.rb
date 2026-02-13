class CurrentSemesterSubjectsController < ApplicationController
  def index
    @subjects = current_degree_plan.subjects.current_semester.order(:code)
  end
end
