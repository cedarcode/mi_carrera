class SubjectGroupsController < ApplicationController
  def show
    @subject_group = degree_subject_groups.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def degree_subject_groups
    current_degree.subject_groups
  end
end
