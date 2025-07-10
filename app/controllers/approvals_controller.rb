class ApprovalsController < ApplicationController
  before_action :set_approvable
  before_action :set_filter_categories

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
      subjects = current_degree.subjects.where(category: @filter_categories).ordered_by_category_and_name
      @subjects = TreePreloader.preload(subjects).select do |subject|
        current_student.approved?(subject.course) ||
          (!subject.hidden_by_default? && current_student.available?(subject.course))
      end
    end

    render :update
  end

  def set_approvable
    @approvable = Approvable.find(params[:approvable_id])
  end

  def set_filter_categories
    @filter_categories = params[:filter_categories] || Subject::MAIN_CATEGORIES
  end
end
