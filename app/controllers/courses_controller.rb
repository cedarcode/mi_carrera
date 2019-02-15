class CoursesController < ApplicationController
  def index
    @courses = Course.order(:id)
    @credits = 0
    if session[:approved_courses]
      session[:approved_courses].each do |course_id|
        course = Course.find(course_id)
        @credits += course.credits
      end
    end
  end

  def approve
    if session[:approved_courses].nil?
      session[:approved_courses] = [course.id]
    elsif params[:course][:approved] == "yes"
      session[:approved_courses] += [course.id]
    elsif params[:course][:approved] == "no"
      session[:approved_courses] -= [course.id]
    end
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  def course
    @course ||= Course.find(params[:id])
  end
end
