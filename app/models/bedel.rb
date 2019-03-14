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
    remove_dependants_approvals(dependency_item)
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
    enough_credits?(dependency_item) &&
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

  def exam_credits(subjects_collection = Subject)
    @exam_credits ||= subjects_collection.joins(:exam).where(subjects: { id: store[:approved_exams] }).sum(:credits)
  end

  def course_credits(subjects_collection = Subject)
    @course_credits ||=
      subjects_collection
      .includes(:exam)
      .where(dependency_items: { subject_id: nil }, subjects: { id: store[:approved_courses] })
      .sum(:credits)
  end

  def remove_dependants_approvals(dependency_item)
    dependency_item.dependants.each do |dependant|
      if approved?(dependant)
        remove_approval(dependant)
      end
    end
  end

  def enough_credits?(dependency_item)
    dependency_item.credits_prerequisites.all? do |credit_prerequisite|
      group = credit_prerequisite.subjects_group
      if group
        group_credits(group) >= credit_prerequisite.credits_needed
      else
        credits >= credit_prerequisite.credits_needed
      end
    end
  end

  def group_credits(group)
    group_subjects = Subject.joins(:group).where(subjects_groups: { name: group.name })
    exam_credits(group_subjects) + course_credits(group_subjects)
  end
end
