class ProfilesController < ApplicationController
  helper_method :bedel

  def show
    @groups_and_credits = bedel.credits_by_group
    respond_to do |format|
      format.html
    end
  end

  private

  def bedel
    @bedel ||= Bedel.new(session)
  end
end
