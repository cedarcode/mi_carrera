class GuestSessionsController < ApplicationController
  def create
    session[:guest] = true
    redirect_to root_path
  end
end
