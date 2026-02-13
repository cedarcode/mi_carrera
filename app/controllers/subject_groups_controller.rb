class SubjectGroupsController < ApplicationController
  def show
    @subject_group = current_degree_plan.subject_groups.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
end
