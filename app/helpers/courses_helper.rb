module CoursesHelper
  def define_initial_state(course)
    return !session[:approved_courses].nil? && session[:approved_courses].include?("#{course.id}")
  end
end
