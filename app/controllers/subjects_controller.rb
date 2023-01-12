class SubjectsController < ApplicationController
  def index
    @subjects =
      Bedel
      .approvables_by_id
      .filter_map do |_approvable_id, approvable|
        if approvable[:is_exam] == false && approvable[:subject_id] && bedel.able_to_do?(approvable)
          Bedel.subjects_by_id[approvable[:subject_id]]
        end
      end
      .sort_by { |subject| [subject.semester ? 0 : 1, subject.semester] }
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
    @subjects =
      Bedel.subjects_by_id
           .sort_by { |_id, subject| [subject.semester ? 0 : 1, subject.semester] }
           .filter_map { |_id, subject| subject if bedel.able_to_do?(subject.stored_course) }

    respond_to do |format|
      format.html { render '_subjects_bulk_approve', layout: false }
    end
  end

  def all
    @subjects = Bedel.subjects_by_id.values.sort_by { |subject| [subject.semester ? 0 : 1, subject.semester] }
  end

  private

  def subject
    @subject ||= Bedel.subjects_by_id[params[:id].to_i]
  end
end
