class HomeController < ApplicationController
  def index
  end

  def visitor
    session[:visitor] = "visitor"
    redirect_to root_path
  end
end
