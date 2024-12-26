class ApplicationController < ActionController::Base
  helper_method :current_student
  rate_limit to: 20, within: 10.seconds

  private

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end
end
