class SubjectPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_feature_enabled!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.subject_plans.create!(subject_plan_params)

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
    @planned_subjects =
      preloader.preload_subjects(
        current_user
          .planned_subjects.select('subjects.*', 'subject_plans.semester')
          .order('subject_plans.semester')
      )

    @not_planned_approved_subjects, @not_planned_subjects =
      preloader.preload_subjects(
        Subject.ordered_by_category_and_name
      ).reject { |subject|
        current_user.planned?(subject)
      }.partition { |subject| current_student.approved?(subject) }
  end

  def preloader
    @preloader ||= TreePreloader.new
  end

  def subject_plan_params
    params.require(:subject_plan).permit(:subject_id, :semester)
  end
end
