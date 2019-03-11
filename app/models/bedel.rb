class Bedel
  def initialize(store)
    @store = store

    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

  def add_approval(dependency_item)
    if dependency_item.is_exam?
      store[:approved_exams] += [dependency_item.subject_id]
    else
      store[:approved_courses] += [dependency_item.subject_id]
    end
  end

  def remove_approval(dependency_item)
    if dependency_item.is_exam?
      store[:approved_exams] -= [dependency_item.subject_id]
    else
      store[:approved_courses] -= [dependency_item.subject_id]
    end
  end

  def credits
    exam_credits + course_credits
  end

  def approved?(dependency_item)
    if dependency_item.is_exam?
      store[:approved_exams].include?(dependency_item.subject_id)
    else
      store[:approved_courses].include?(dependency_item.subject_id)
    end
  end

  def able_to_do?(dependency_item)
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
