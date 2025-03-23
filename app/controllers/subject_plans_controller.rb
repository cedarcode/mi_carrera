class SubjectPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_feature_enabled!
  before_action :set_subject_plan, only: [:update_semester, :destroy]

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    @subject_plan = current_user.subject_plans.build(subject_plan_params)

    if @subject_plan.save
      respond_with_streams(
        build_planner_streams(@subject_plan.semester),
        success_path: subject_plans_path,
        notice: 'Subject plan created successfully.'
      )
    else
      respond_with_error(
        @subject_plan.errors.full_messages.join(', '),
        error_path: subject_plans_path
      )
    end
  end

  def update_semester
    new_semester = params[:semester].to_i

    if @subject_plan.update(semester: new_semester)
      respond_with_streams(
        build_planner_streams(new_semester),
        success_path: subjects_path,
        notice: 'Semester was successfully updated.'
      )
    else
      respond_with_error(
        @subject_plan.errors.full_messages.join(', '),
        error_path: subjects_path
      )
    end
  end

  def destroy
    if @subject_plan.destroy
      respond_with_streams(
        build_planner_streams(@subject_plan.semester),
        success_path: subject_plans_path
      )
    else
      respond_with_error(
        @subject_plan.errors.full_messages.join(', '),
        error_path: subject_plans_path
      )
    end
  end

  private

  def respond_with_streams(streams, success_path:, notice: nil)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: streams }
      format.html do
        redirect_to success_path, notice: notice if notice.present?
        redirect_to success_path if notice.blank?
      end
    end
  end

  def respond_with_error(error_message, error_path:)
    streams = build_planner_error_stream(error_message)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: streams }
      format.html { redirect_to error_path, alert: error_message }
    end
  end

  def ensure_feature_enabled!
    redirect_to root_path, alert: 'Feature is not available' if ENV['ENABLE_PLANNER'].blank?
  end

  def set_planned_and_not_planned_subjects
    @planned_subjects = TreePreloader.new(
      current_user.planned_subjects
        .select('subjects.*', 'subject_plans.semester')
        .order('subject_plans.semester')
    ).preload

    @not_planned_approved_subjects, @not_planned_subjects =
      TreePreloader.new(Subject.ordered_by_name).preload
                   .reject { |subject| current_user.planned?(subject) }
                   .partition { |subject| current_user.approved?(subject) }
  end

  def build_planner_streams(semester)
    set_planned_and_not_planned_subjects
    streams = []
    streams << turbo_stream.update('credits-counter', partial: 'shared/credits_counter')
    streams << turbo_stream.update(
      'total-planned-credits',
      partial: 'subject_plans/credits_counter',
      locals: { planned_subjects: @planned_subjects }
    )
    streams << turbo_stream.update(
      'planned-subjects',
      partial: 'subjects/planned_subjects_list',
      locals: { planned_subjects: @planned_subjects }
    )

    handle_not_planned_subjects(streams)
    handle_semester_credits(streams, semester)
    streams
  end

  def handle_not_planned_subjects(streams)
    if @not_planned_approved_subjects.any?
      streams << turbo_stream.update(
        'not-planned-approved-subjects-section',
        partial: 'subjects/not_planned_subjects_list',
        locals: { subjects: @not_planned_approved_subjects, turbo_stream: true }
      )
      streams << turbo_stream.remove('not-planned-approved-subjects-section')
      streams << turbo_stream.after(
        'planned-subjects',
        partial: 'subjects/not_planned_subjects_list',
        locals: { subjects: @not_planned_approved_subjects, turbo_stream: true }
      )
    else
      streams << turbo_stream.remove('not-planned-approved-subjects-section')
    end
  end

  def handle_semester_credits(streams, semester)
    semester_subjects = @planned_subjects.select { |s| s.semester == semester }
    streams << turbo_stream.update(
      "semester-#{semester}-credits",
      partial: 'subject_plans/credits_counter',
      locals: { planned_subjects: semester_subjects }
    )
  end

  def build_planner_error_stream(message)
    turbo_stream.replace('flash', partial: 'shared/flash', locals: { alert: message })
  end

  def subject_plan_params
    params.require(:subject_plan).permit(:subject_id, :semester)
  end

  def set_subject_plan
    @subject_plan = current_user.subject_plans.find(params[:id])
  end
end
