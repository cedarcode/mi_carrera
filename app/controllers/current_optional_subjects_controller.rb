class CurrentOptionalSubjectsController < ApplicationController
  def index
    @subjects = Subject.current_semester_optionals.order(:code)

    respond_to do |format|
      format.html
    end
  end
end
