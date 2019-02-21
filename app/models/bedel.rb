class Bedel
  def initialize(session)
    @session = session
    @session[:approved_courses] ||= []
    @session[:approved_exams] ||= []
  end

  def add_approved_course(subject)
    @session[:approved_courses] += [subject.id]
  end

  def remove_approve_course(subject)
    @session[:approved_courses] -= [subject.id]
  end

  def add_approved_exam(subject)
    @session[:approved_exams] += [subject.id]
  end

  def remove_approve_exam(subject)
    @session[:approved_exams] -= [subject.id]
  end

  def calculate_credits
    credits = 0

    @session[:approved_exams].each do |subject_id|
      subject = Subject.find(subject_id)
      credits += subject.credits
    end

    credits
  end

  def approved_course?(subject)
    @session[:approved_courses].include?(subject.id)
  end

  def approved_exam?(subject)
    @session[:approved_exams].include?(subject.id)
  end
end
