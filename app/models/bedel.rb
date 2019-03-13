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
      if group.name == "Carrera de Ingeniería en Computación"
        credits >= credit_prerequisite.credits_needed
      else
        group_credits(group) >= credit_prerequisite.credits_needed
      end
    end
  end

  def group_credits(group)
    group_subjects = Subject.joins(:group).where(subjects_groups: { name: group.name })
    group_exam_credits = group_subjects.joins(:exam).where(subjects: { id: store[:approved_exams] }).sum(:credits)
    group_course_credits = group_subjects
                           .includes(:exam)
                           .where(dependency_items: { subject_id: nil }, subjects: { id: store[:approved_courses] })
                           .sum(:credits)
    group_exam_credits + group_course_credits
  end
end
