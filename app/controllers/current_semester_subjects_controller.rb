class CurrentSemesterSubjectsController < ApplicationController
  def index
    @subjects = current_degree.subjects.current_semester.order(:code)
  end
end
