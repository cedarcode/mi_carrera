class SubjectPlansController < ApplicationController
  before_action :authenticate_user!

  def index
    set_planned_and_not_planned_subjects
  end

  def create
    current_user.subject_plans.create!(subject_plan_params)

    @semesters_to_refresh = [subject_plan_params[:semester].to_i]

    set_planned_and_not_planned_subjects

    @reload_not_planned_approved_subjects = true

    render :update
  end

  def update
    subject_plan = current_user.subject_plans.find_by!(subject_id: params[:subject_id])
    previous_semester = subject_plan.semester
    new_semester = subject_plan_params[:semester].to_i
    subject_plan.update!(semester: new_semester)

    @semesters_to_refresh = [previous_semester, new_semester]

    set_planned_and_not_planned_subjects
  end

  def destroy
    subject_plan = current_user.subject_plans.find_by!(subject_id: params[:subject_id])
    @semesters_to_refresh = [subject_plan.semester]
    subject_plan.destroy!

    set_planned_and_not_planned_subjects

    @reload_not_planned_approved_subjects = true

    render :update
  end

  private

  def set_planned_and_not_planned_subjects
    @planned_subjects =
      TreePreloader.preload(current_user.planned_subjects.select('subjects.*', 'subject_plans.semester')
        .order('subject_plans.semester'))

    @not_planned_approved_subjects = current_student
                                     .approved_subjects
                                     .where.not(id: @planned_subjects)
                                     .ordered_by_category
                                     .ordered_by_short_or_full_name
                                     .load

    # Calculate credits only from planned subjects (those positioned in semesters)
    planned_credits_by_group = @planned_subjects
                                 .group_by(&:group_id)
                                 .transform_values { |subjects| subjects.sum(&:credits) }

    @groups_and_credits = current_degree.subject_groups.find_each.map do |subject_group|
      credits = planned_credits_by_group[subject_group.id] || 0
      {
        subject_group:,
        credits:,
        credits_needed_reached: credits >= subject_group.credits_needed,
      }
    end
    @groups_and_credits.sort_by! { |group_and_credits| group_and_credits[:subject_group].name }

    @all_group_credits_met = @groups_and_credits.all? { |group_and_credits| group_and_credits[:credits_needed_reached] }
    @total_credits = @groups_and_credits.pluck(:credits).sum
  end

  def subject_plan_params
    params.require(:subject_plan).permit(:subject_id, :semester)
  end
end
