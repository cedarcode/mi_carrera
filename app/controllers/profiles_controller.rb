class ProfilesController < ApplicationController
  def show
    @groups_and_credits = bedel.credits_by_group
    respond_to do |format|
      format.html { 'profile' }
    end
  end

  private

  def bedel
    @bedel ||= Bedel.new(session)
  end
end
