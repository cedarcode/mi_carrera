class SubjectGroupsController < ApplicationController
  def show
    @subject_group = degree_subject_groups.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  delegate :degree_subject_groups, to: :current_student, private: true
end
