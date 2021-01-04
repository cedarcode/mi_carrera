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
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      @bedel ||= Bedel.new(user.approvals, user)
    else
      @bedel ||= Bedel.new(session)
    end
  end
end
