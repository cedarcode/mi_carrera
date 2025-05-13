class ApplicationController < ActionController::Base
  helper_method :current_student
  rate_limit to: 20, within: 10.seconds
  set_current_tenant_through_filter
  before_action :switch_tenant

  private

  def switch_tenant
    set_current_tenant(current_student.degree)
  end

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end
end
