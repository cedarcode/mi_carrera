class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.new.preload.select do |subject|
      current_student.approved?(subject.course) ||
        (!subject.hidden_by_default? && current_student.available?(subject.course))
    end
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  def all
    @subjects = TreePreloader.new.preload
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end
