class Bedel
  def initialize(store)
    @store = store

    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

  def add_approval(approvable)
    if able_to_do?(approvable)
      if approvable.is_exam?
        store[:approved_exams] += [approvable.subject_id]
      else
        store[:approved_courses] += [approvable.subject_id]
      end
    else
      false
    end
  end

  def remove_approval(approvable)
    if approvable.is_exam?
      store[:approved_exams] -= [approvable.subject_id]
    else
      store[:approved_courses] -= [approvable.subject_id]
    end

    refresh_approvals
  end

  def refresh_approvals
    original_count = store[:approved_exams].size + store[:approved_courses].size

    to_remove = []
    store[:approved_exams].each do |subject_id|
      approvable = Approvable.find_by(subject_id: subject_id, is_exam: true)

      if !able_to_do?(approvable)
        to_remove += [subject_id]
      end
    end
    store[:approved_exams] -= to_remove

    to_remove = []
    store[:approved_courses].each do |subject_id|
      approvable = Approvable.find_by(subject_id: subject_id, is_exam: false)

      if !able_to_do?(approvable)
        to_remove += [subject_id]
      end
    end
    store[:approved_courses] -= to_remove

    new_count = store[:approved_exams].size + store[:approved_courses].size

    if new_count != original_count
      refresh_approvals
    end
  end

  def credits(group = nil)
    exam_credits(group) + course_credits(group)
  end

  def credits_by_group
    SubjectGroup.find_each.map do |subject_group|
      { subject_group: subject_group, credits: credits(subject_group) }
    end
  end

  def approved?(item)
    case item
    when Subject
      if item.exam
        approved?(item.exam)
      else
        approved?(item.course)
      end
    when Approvable
      if item.is_exam?
        store[:approved_exams].include?(item.subject_id)
      else
        store[:approved_courses].include?(item.subject_id)
      end
    end
  end

  def able_to_do?(item)
    case item
    when Subject
      able_to_do?(item.course)
    when Approvable
      if item.prerequisite_tree
        meets_prerequisites?(item.prerequisite_tree)
      else
        true
      end
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
      .where(approvables: { subject_id: nil }, subjects: { id: store[:approved_courses] })
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
      approvable_needed = prerequisite_item.approvable_needed
      if approvable_needed.is_exam
        store[:approved_exams].include?(approvable_needed.subject_id)
      else
        store[:approved_courses].include?(approvable_needed.subject_id)
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
      elsif prerequisite_item.logical_operator == "not"
        !meets_prerequisites?(prerequisite_item.operands_prerequisites[0])
      end
    end
  end
end
