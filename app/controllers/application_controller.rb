class ApplicationController < ActionController::Base
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_student, :current_degree_plan
  rate_limit to: 20, within: 10.seconds

  # The app only serves HTML. Rails already maps UnknownFormat to a 406, but letting it
  # raise reports every scanner asking for JSON as an error. Answer the 406 ourselves.
  rescue_from ActionController::UnknownFormat do
    head :not_acceptable
  end

  private

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end

  def current_degree_plan
    @current_degree_plan ||= current_student.degree_plan
  end
end
