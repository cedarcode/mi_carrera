class CurrentOptionalSubjectsController < ApplicationController
  def index
    @subjects = current_degree.subjects.current_semester_optionals.order(:code)
  end
end
