class ApplicationController < ActionController::Base
  helper_method :bedel

  private

  def bedel
    if current_user
      current_user.approvals ||= []
      @bedel ||= Bedel.new(current_user.approvals, current_user)
    else
      session[:approved_approvable_ids] ||= []
      @bedel ||= Bedel.new(session[:approved_approvable_ids])
    end
  end
end
