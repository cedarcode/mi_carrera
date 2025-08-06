class ApplicationController < ActionController::Base
  helper_method :current_student
  rate_limit to: 20, within: 10.seconds
  before_action :reset_passkey_authentication

  private

  def current_student
    @current_student ||= current_user ? UserStudent.new(current_user) : CookieStudent.new(cookies)
  end

  def current_degree
    @current_degree ||= current_student.degree
  end

  def reset_passkey_authentication
    session[:password_passkey_verification] = false
  end
end
