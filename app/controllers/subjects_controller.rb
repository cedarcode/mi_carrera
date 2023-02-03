class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.new.preload.select { |subject| current_student.available?(subject.course) }
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  def all
    @subjects = Subject.ordered_by_semester_and_name
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end
