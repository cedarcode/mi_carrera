class SubjectPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_feature_enabled!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.subject_plans.create!(subject_plan_params)

    @semester_to_refresh = subject_plan_params[:semester].to_i

    set_planned_and_not_planned_subjects

    render :update
  end

  def destroy
    subject_plan = current_user.subject_plans.find_by!(subject_id: params[:subject_id])
    @semester_to_refresh = subject_plan.semester
    subject = subject_plan.subject
    subject_plan.destroy!

    set_planned_and_not_planned_subjects

    @not_planned_approved_subjects_was_empty = @not_planned_approved_subjects == [subject]

    render :update
  end

  private

  def ensure_feature_enabled!
    redirect_to root_path if ENV['ENABLE_PLANNER'].blank?
  end

  def set_planned_and_not_planned_subjects
    @planned_subjects =
      TreePreloader.preload(current_user.planned_subjects.select('subjects.*', 'subject_plans.semester')
        .order('subject_plans.semester'))
    @not_planned_approved_subjects, @not_planned_subjects =
      TreePreloader.preload(Subject.ordered_by_category.ordered_by_short_or_full_name).reject { |subject|
        current_user.planned?(subject)
      }.partition { |subject| current_student.approved?(subject) }
  end

  def subject_plan_params
    params.require(:subject_plan).permit(:subject_id, :semester)
  end
end
