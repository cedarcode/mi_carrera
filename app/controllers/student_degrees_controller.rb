class StudentDegreesController < ApplicationController
  def update
    degree_key = params[:degree]
    current_student.change_degree(degree_key)
    redirect_to root_path
  end
end
