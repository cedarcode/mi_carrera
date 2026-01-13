class ApplicationController < ActionController::Base
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_student
  rate_limit to: 20, within: 10.seconds

  private

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end

  def current_degree
    @current_degree ||= current_student.degree
  end
end
