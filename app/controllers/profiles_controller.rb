class ProfilesController < ApplicationController
  def show
    @groups_and_credits = bedel.credits_by_group
    respond_to do |format|
      format.html
    end
  end
end
