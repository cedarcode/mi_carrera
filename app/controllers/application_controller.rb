class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :bedel

  def current_user
    User.find_by(id: session[:user_id])
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
