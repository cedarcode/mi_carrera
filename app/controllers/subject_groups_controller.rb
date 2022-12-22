class SubjectGroupsController < ApplicationController

  def show
    @subject_group = SubjectGroup.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

end
