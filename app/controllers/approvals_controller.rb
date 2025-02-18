class ApprovalsController < ApplicationController
  before_action :set_approvable

  def create
    previously_graduated = current_student.graduated?

    current_student.add(@approvable)

    @graduated = current_student.graduated? && !previously_graduated

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
      @subjects = TreePreloader.new(Subject.ordered_by_category_and_name).preload.select do |subject|
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
