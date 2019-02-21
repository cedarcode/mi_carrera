class SubjectsController < ApplicationController
  before_action :set_bedel

  def index
    @subjects = Subject.order(:semester)
    @credits = @bedel.calculate_credits
  end

  def approve
    if params[:subject][:course_approved]
      if params[:subject][:course_approved] == "yes"
        @bedel.add_approved_course(subject)
      elsif params[:subject][:course_approved] == "no"
        @bedel.remove_approved_course(subject)
      end
    elsif params[:subject][:exam_approved]
      if params[:subject][:exam_approved] == "yes"
        @bedel.add_approved_exam(subject)
      elsif params[:subject][:exam_approved] == "no"
        @bedel.remove_approved_exam(subject)
      end
    end
    respond_to do |format|
      format.json { render json: { credits: @bedel.calculate_credits } }
    end
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  private

  def set_bedel
    @bedel ||= Bedel.new(session)
  end

  def subject
    @subject ||= Subject.find(params[:id])
  end
end
