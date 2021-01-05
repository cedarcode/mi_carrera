class ProfilesController < ApplicationController
  def show
    @groups_and_credits = bedel.credits_by_group
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
