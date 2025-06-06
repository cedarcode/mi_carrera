class SubjectGroupsController < ApplicationController
  def show
    @subject_group = degree_subject_groups.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private

  def degree_subject_groups
    current_student.degree_subject_groups
  end
end
