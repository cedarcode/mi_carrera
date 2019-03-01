class SubjectsController < ApplicationController
  helper_method :bedel

  def index
    @subjects = Subject.order(:semester).select { |subject| bedel.able_to_do?(subject, false) }
  end

  def approve
    if params[:subject][:course_approved]
      if params[:subject][:course_approved] == "yes"
        bedel.add_approved_course(subject)
      elsif params[:subject][:course_approved] == "no"
        bedel.remove_approved_course(subject)
      end
    elsif params[:subject][:exam_approved]
      if params[:subject][:exam_approved] == "yes"
        bedel.add_approved_exam(subject)
      elsif params[:subject][:exam_approved] == "no"
        bedel.remove_approved_exam(subject)
      end
    end
    if params[:subject][:course_approved]
      respond_to do |format|
        format.json { render json: { credits: bedel.credits, able_to_enroll_exam: bedel.able_to_do?(@subject, true) } }
      end
    else
      respond_to do |format|
        format.json { render json: { credits: bedel.credits } }
      end
    end
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  private

  def bedel
    @bedel ||= Bedel.new(session)
  end

  def subject
    @subject ||= Subject.find(params[:id])
  end
end
