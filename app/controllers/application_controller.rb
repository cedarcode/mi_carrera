class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :bedel
  helper_method :authenticate

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

  def authenticate
    if !current_user and !session[:guest]
      redirect_to home_path
    end
  end
end
