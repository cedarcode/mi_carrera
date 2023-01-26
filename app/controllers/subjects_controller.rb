class SubjectsController < ApplicationController
  def index
    @subjects = TreePreloader.new.preload.select { |subject| bedel.able_to_do?(subject.course) }
  end

  def approve
    if params[:subject][:course_approved]
      if params[:subject][:course_approved] == "yes"
        bedel.add_approval(subject.course)
      elsif params[:subject][:course_approved] == "no"
        bedel.remove_approval(subject.course)
      end
    elsif params[:subject][:exam_approved]
      if params[:subject][:exam_approved] == "yes"
        bedel.add_approval(subject.exam)
      elsif params[:subject][:exam_approved] == "no"
        bedel.remove_approval(subject.exam)
      end
    end

    unless params[:only_approvables]
      @subjects = TreePreloader.new.preload.select { |subject| bedel.able_to_do?(subject.course) }
    end
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
