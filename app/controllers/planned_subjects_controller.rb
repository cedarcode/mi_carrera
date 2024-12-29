class PlannedSubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_feature_enabled!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.planned_subjects.create(subject_id: params[:subject_id], semester: params[:semester])

    set_planned_and_not_planned_subjects

    redirect_to planned_subjects_path
  end

  def destroy
    planned_subject = current_user.planned_subjects.find_by!(subject_id: params[:subject_id])
    planned_subject.destroy

    set_planned_and_not_planned_subjects

    redirect_to planned_subjects_path
  end

  private

  def ensure_feature_enabled!
    redirect_to root_path, alert: 'Feature is not available' if ENV['ENABLE_PLANNER'].blank?
  end

  def set_planned_and_not_planned_subjects
    @planned_subjects = current_user.planned_subjects.includes(:subject).order(:semester)
    @not_planned_approved_subjects, @not_planned_subjects = TreePreloader.new.preload.reject { |subject|
      current_user.planned?(subject)
    }.partition { |subject| current_student.approved?(subject) }
  end
end
