class SubjectGroupsController < ApplicationController
  helper_method :bedel

  def show
    @subject_group = SubjectGroup.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private

  def bedel
    @bedel ||= Bedel.new(session)
  end
end
