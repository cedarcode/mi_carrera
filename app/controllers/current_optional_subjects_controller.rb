class CurrentOptionalSubjectsController < ApplicationController
  def index
    @subjects = Subject.current_semester_optionals.order(:code)
  end
end
