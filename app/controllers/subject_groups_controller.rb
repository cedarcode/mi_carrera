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
    if current_user
      @bedel ||= Bedel.new(current_user.approvals, current_user)
    else
      @bedel ||= Bedel.new(session)
    end
  end
end
