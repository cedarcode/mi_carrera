class CoursesController < ApplicationController
  def index
    @courses = Course.order(:semester)
    @credits = credits
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
      format.json { render json: { credits: credits } }
    end
  end

  def show
    respond_to do |format|
      format.html { course }
    end
  end

  private

  def course
    @course ||= Course.find(params[:id])
  end

  def credits
    credits = 0

    if session[:approved_courses]
      session[:approved_courses].each do |course_id|
        course = Course.find(course_id)
        credits += course.credits
      end
    end

    credits
  end
end
