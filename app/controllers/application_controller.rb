class ApplicationController < ActionController::Base
  helper_method :current_student

  private

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end
end
