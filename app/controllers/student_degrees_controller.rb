class StudentDegreesController < ApplicationController
  def update
    degree_id = params[:degree]
    current_student.change_degree(degree_id)
    redirect_to root_path
  end
end
