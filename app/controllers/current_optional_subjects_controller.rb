class CurrentOptionalSubjectsController < ApplicationController
  def index
    @subjects = Subject.where(current_optional_subject: true).order(:code)

    respond_to do |format|
      format.html
    end
  end
end
