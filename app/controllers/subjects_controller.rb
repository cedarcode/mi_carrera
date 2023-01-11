class SubjectsController < ApplicationController
  def index
    @subjects =
      Subject
      .includes(course: :prerequisite_tree, exam: :prerequisite_tree)
      .order(:semester)
      .select { |subject| bedel.able_to_do?(subject.stored_course) }
  end

  def approve
    if params[:subject][:course_approved]
      if params[:subject][:course_approved] == "yes"
        bedel.add_approval(subject.stored_course)
      elsif params[:subject][:course_approved] == "no"
        bedel.remove_approval(subject.stored_course)
      end
    elsif params[:subject][:exam_approved]
      if params[:subject][:exam_approved] == "yes"
        bedel.add_approval(subject.stored_exam)
      elsif params[:subject][:exam_approved] == "no"
        bedel.remove_approval(subject.stored_exam)
      end
    end
    data = { credits: bedel.credits }
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def able_to_enroll
    able_to_enroll = { exam: bedel.able_to_do?(subject.stored_exam) }
    respond_to do |format|
      format.json { render json: able_to_enroll }
    end
  end

  def show
    respond_to do |format|
      format.html { subject }
    end
  end

  def list_subjects
    @subjects = Subject.order(:semester).select { |subject| bedel.able_to_do?(subject.stored_course) }
    respond_to do |format|
      format.html { render '_subjects_bulk_approve', layout: false }
    end
  end

  def all
    @subjects = Subject.order(:semester)
  end

  private

  def subject
    @subject ||= Subject.find(params[:id])
  end
end
