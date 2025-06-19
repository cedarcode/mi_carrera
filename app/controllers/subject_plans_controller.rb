class SubjectPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_feature_enabled!

  def index
    set_planned_and_not_planned_subjects

    @approved_subjects_card_opened = flash[:approved_subjects_card_opened]
  end

  def create
    current_user.subject_plans.create!(subject_plan_params)
    flash[:approved_subjects_card_opened] = params[:approved_subjects_card_opened] == 'true'

    @semester = subject_plan_params[:semester].to_i

    set_planned_and_not_planned_subjects
  end

  def destroy
    subject_plan = current_user.subject_plans.find_by!(subject_id: params[:subject_id])
    subject_plan.destroy!

    redirect_to subject_plans_path
  end

  private

  def ensure_feature_enabled!
    redirect_to root_path if ENV['ENABLE_PLANNER'].blank?
  end

  def set_planned_and_not_planned_subjects
    @planned_subjects =
      TreePreloader.new(current_user.planned_subjects.select('subjects.*', 'subject_plans.semester')
        .order('subject_plans.semester')).preload
    @not_planned_approved_subjects, @not_planned_subjects =
      TreePreloader.new(Subject.ordered_by_category.ordered_by_short_or_full_name).preload.reject { |subject|
        current_user.planned?(subject)
      }.partition { |subject| current_student.approved?(subject) }
  end

  def subject_plan_params
    params.require(:subject_plan).permit(:subject_id, :semester)
  end
end
