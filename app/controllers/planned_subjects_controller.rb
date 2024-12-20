class PlannedSubjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.planned_subjects.create(subject_id: params[:subject_id])

    set_planned_and_not_planned_subjects

    render :create
  end

  def destroy
    planned_subject = current_user.planned_subjects.find_by!(subject_id: params[:subject_id])
    planned_subject.destroy

    set_planned_and_not_planned_subjects

    render :destroy
  end

  private

  def set_planned_and_not_planned_subjects
    @planned_subjects, @not_planned_subjects = TreePreloader.new.preload.partition do |subject|
      current_student.approved?(subject.course) || current_user.planned?(subject)
    end
  end
end
