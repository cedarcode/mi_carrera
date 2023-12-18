class ApprovalsController < ApplicationController
  before_action :set_approvable

  def create
    previous_total_credits = current_student.total_credits

    current_student.add(@approvable)

    group_credits_met = SubjectGroup.all.all? { |group| current_student.group_credits_met?(group) }

    @graduated = current_student.total_credits >= 450 && previous_total_credits < 450 && group_credits_met

    render_turbo_stream
  end

  def destroy
    current_student.remove(@approvable)
    render_turbo_stream
  end

  private

  def render_turbo_stream
    if params[:subject_show] == "true"
      @subject = @approvable.subject
    else
      @subjects = TreePreloader.new.preload.select do |subject|
        current_student.approved?(subject.course) ||
          (!subject.hidden_by_default? && current_student.available?(subject.course))
      end
    end

    render :update
  end

  def set_approvable
    @approvable = Approvable.find(params[:approvable_id])
  end
end
