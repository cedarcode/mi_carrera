class ApplicationController < ActionController::Base
  helper_method :current_student
  rate_limit to: 20, within: 10.seconds
  before_action :switch_tenant

  private

  def switch_tenant
    Apartment::Tenant.switch!(current_student.degree_key)
  end

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end
end
