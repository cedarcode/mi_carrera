class SubjectsController < ApplicationController
  def index
    @subjects = Subject.order(:semester)
    @credits = credits
  end

  def approve
    if session[:approved_subjects].nil?
      session[:approved_subjects] = [subject.id]
    elsif params[:subject][:approved] == "yes"
      session[:approved_subjects] += [subject.id]
    elsif params[:subject][:approved] == "no"
      session[:approved_subjects] -= [subject.id]
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

    if session[:approved_subjects]
      session[:approved_subjects].each do |subject_id|
        subject = Subject.find(subject_id)
        credits += subject.credits
      end
    end

    credits
  end
end
