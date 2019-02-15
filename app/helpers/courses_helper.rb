module CoursesHelper
  def course_approved?(course)
    return !session[:approved_courses].nil? && session[:approved_courses].include?(course.id)
  end
end
