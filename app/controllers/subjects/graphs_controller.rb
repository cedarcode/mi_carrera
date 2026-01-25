module Subjects
  class GraphsController < ApplicationController
    def show
      categories = params[:categories] || []

      @subjects = current_degree.subjects
        .where(category: categories)
        .includes(:course, :exam)

      TreePreloader.preload(@subjects)
    end
  end
end
