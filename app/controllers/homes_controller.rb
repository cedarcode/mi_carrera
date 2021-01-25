class HomesController < ApplicationController
  before_action :skip_home

  def show
  end

  private

  def skip_home
    if session[:guest]
      redirect_to root_path
    end
  end
end
