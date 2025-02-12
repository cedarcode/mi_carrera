class SubjectPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_feature_enabled!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.subject_plans.create!(subject_id: params[:subject_id])

    redirect_to subject_plans_path
  end

  def destroy
    subject_plan = current_user.subject_plans.find_by!(subject_id: params[:subject_id])
    subject_plan.destroy!

    redirect_to subject_plans_path
  end

  private

  def ensure_feature_enabled!
    redirect_to root_path, alert: 'Feature is not available' if ENV['ENABLE_PLANNER'].blank?
  end

  def set_planned_and_not_planned_subjects
    @planned_subjects, @not_planned_subjects = TreePreloader.new.preload_subjects.partition do |subject|
      current_student.approved?(subject) || current_user.planned?(subject)
    end
  end
end
