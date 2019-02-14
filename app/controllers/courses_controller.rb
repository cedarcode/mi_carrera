class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def approve
    if session[:approved_courses].nil?
      session[:approved_courses] = [params[:course_id]]
    elsif session[:approved_courses].include? params[:course_id]
      session[:approved_courses] -= [params[:course_id]]
    else
      session[:approved_courses] += [params[:course_id]]
    end
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private
   def courses_params
     params.require(:course).permit(:course_id)
   end
end
