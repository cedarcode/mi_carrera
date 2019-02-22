class Bedel
  def initialize(store)
    @store = store

    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

  def add_approved_course(subject)
    store[:approved_courses] += [subject.id]
  end

  def remove_approved_course(subject)
    store[:approved_courses] -= [subject.id]
  end

  def add_approved_exam(subject)
    store[:approved_exams] += [subject.id]
  end

  def remove_approved_exam(subject)
    store[:approved_exams] -= [subject.id]
  end

  def credits
    Subject.where(id: store[:approved_exams]).sum(:credits)
  end

  def approved_course?(subject)
    store[:approved_courses].include?(subject.id)
  end

  def approved_exam?(subject)
    store[:approved_exams].include?(subject.id)
  end

  private

  attr_reader :store
end
