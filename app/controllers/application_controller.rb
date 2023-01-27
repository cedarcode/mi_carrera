class ApplicationController < ActionController::Base
  helper_method :bedel

  private

  def bedel
    @bedel ||= if current_user
                 current_user.approvals ||= []
                 Bedel.new(current_user.approvals, current_user)
               else
                 session[:approved_approvable_ids] ||= []
                 Bedel.new(session[:approved_approvable_ids])
               end
  end
end
