class PlannedSubjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.planned_subjects.create(subject_id: params[:subject_id])

    render_turbo_stream
  end

  def destroy
    planned_subject = current_user.planned_subjects.find_by!(subject_id: params[:subject_id])
    planned_subject.destroy

    render_turbo_stream
  end

  private

  def render_turbo_stream
    set_planned_and_not_planned_subjects

    render :update
  end

  def set_planned_and_not_planned_subjects
    @planned_subjects, @not_planned_subjects = TreePreloader.new.preload.partition do |subject|
      current_student.approved?(subject) || current_user.planned?(subject)
    end
  end
end
