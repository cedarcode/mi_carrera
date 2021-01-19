class HomeController < ApplicationController
  before_action :skip_home

  def index
  end

  def guest
    session[:guest] = true
    redirect_to root_path
  end

  private

  def skip_home
    if session[:guest]
      redirect_to root_path
    end
  end
end
