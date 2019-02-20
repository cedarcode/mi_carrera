class SubjectsController < ApplicationController
  def index
    @subjects = Subject.order(:semester)
    @credits = credits
  end

  def approve
    if params[:subject][:course_approved]
      if session[:approved_courses].nil? && params[:subject][:course_approved] == "yes"
        session[:approved_courses] = [subject.id]
      elsif params[:subject][:course_approved] == "yes"
        session[:approved_courses] += [subject.id]
      elsif params[:subject][:course_approved] == "no"
        session[:approved_courses] -= [subject.id]
      end
    elsif params[:subject][:exam_approved]
      if session[:approved_exams].nil? && params[:subject][:exam_approved] == "yes"
        session[:approved_exams] = [subject.id]
      elsif params[:subject][:exam_approved] == "yes"
        session[:approved_exams] += [subject.id]
      elsif params[:subject][:exam_approved] == "no"
        session[:approved_exams] -= [subject.id]
      end
    end
    respond_to do |format|
      format.json { render json: { credits: credits } }
    end
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end

  def credits
    credits = 0

    if session[:approved_exams]
      session[:approved_exams].each do |subject_id|
        subject = Subject.find(subject_id)
        credits += subject.credits
      end
    end

    credits
  end
end
