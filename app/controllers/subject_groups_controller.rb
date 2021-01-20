class SubjectGroupsController < ApplicationController
  before_action :authenticate

  def show
    @subject_group = SubjectGroup.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
end
