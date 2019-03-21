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

  def credits(group = nil)
    exam_credits(group) + course_credits(group)
  end

  def approved?(dependency_item)
    if dependency_item.is_exam?
      store[:approved_exams].include?(dependency_item.subject_id)
    else
      store[:approved_courses].include?(dependency_item.subject_id)
    end
  end

  def able_to_do?(dependency_item)
    if dependency_item.prerequisites
      meets_prerequisites?(dependency_item.prerequisites)
    else
      true
    end
  end

  private

  attr_reader :store

  def exam_credits(group)
    @exam_credits ||= {}
    @exam_credits[group&.id] ||=
      subject_scope(group)
      .joins(:exam)
      .where(subjects: { id: store[:approved_exams] })
      .sum(:credits)
  end

  def course_credits(group)
    @course_credits ||= {}
    @course_credits[group&.id] ||=
      subject_scope(group)
      .includes(:exam)
      .where(dependency_items: { subject_id: nil }, subjects: { id: store[:approved_courses] })
      .sum(:credits)
  end

  def subject_scope(group)
    if group
      group.subjects
    else
      Subject
    end
  end

  def meets_prerequisites?(prerequisite_item)
    case prerequisite_item
    when SubjectPrerequisite
      dependency_item_needed = prerequisite_item.dependency_item_needed
      if dependency_item_needed.is_exam
        store[:approved_exams].include?(dependency_item_needed.subject_id)
      else
        store[:approved_courses].include?(dependency_item_needed.subject_id)
      end
    when CreditsPrerequisite
      credits(prerequisite_item.subject_group) >= prerequisite_item.credits_needed
    when LogicalPrerequisite
      if prerequisite_item.logical_operator == "and"
        prerequisite_item.operands_prerequisites.all? do |prerequisite|
          meets_prerequisites?(prerequisite)
        end
      elsif prerequisite_item.logical_operator == "or"
        prerequisite_item.operands_prerequisites.any? do |prerequisite|
          meets_prerequisites?(prerequisite)
        end
      end
    end
  end
end
