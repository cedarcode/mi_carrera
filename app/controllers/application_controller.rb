class ApplicationController < ActionController::Base
  helper_method :current_student

  private

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies.permanent)
  end

  def remove_approvables_in_cookies
    cookies.permanent[:approved_approvable_ids] = nil
  end
end
