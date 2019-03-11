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
    exam_credits + course_credits
  end

  def approved_course?(subject)
    store[:approved_courses].include?(subject.id)
  end

  def approved_exam?(subject)
    store[:approved_exams].include?(subject.id)
  end

  def able_to_do?(subject, is_exam)
    dependency_item =
      if is_exam
        subject.exam
      else
        subject.course
      end
    credits >= dependency_item.credits_needed &&
      dependency_item.prerequisites.all? do |prerequisite|
        if prerequisite.is_exam
          store[:approved_exams].include?(prerequisite.subject_id)
        else
          store[:approved_courses].include?(prerequisite.subject_id)
        end
      end
  end

  private

  attr_reader :store

  def exam_credits
    @exam_credits ||= Subject.joins(:exam).where(subjects: { id: store[:approved_exams] }).sum(:credits)
  end

  def course_credits
    @course_credits ||=
      Subject
      .includes(:exam)
      .where(dependency_items: { subject_id: nil }, subjects: { id: store[:approved_courses] })
      .sum(:credits)
  end
end
