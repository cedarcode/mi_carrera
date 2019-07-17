class Bedel
  def initialize(store = {})
    @store = store

    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

  def add_approval(approvable)
    expire_enrollment_cache

    if approvable.is_exam?
      store[:approved_exams] += [approvable.subject_id]
    else
      store[:approved_courses] += [approvable.subject_id]
    end
  end

  def remove_approval(approvable)
    expire_enrollment_cache

    if approvable.is_exam?
      store[:approved_exams] -= [approvable.subject_id]
    else
      store[:approved_courses] -= [approvable.subject_id]
    end

    refresh_approvals
  end

  def refresh_approvals
    expire_enrollment_cache

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
    enrollment_state(item) == :yes
  end

  def blocked?(item)
    enrollment_state(item) == :never
  end

  def enrollment_state(item)
    approvable =
      if item.is_a?(Subject)
        item.course
      else
        item
      end

    @enrollment_state ||= {}
    @stack ||= [approvable]

    @enrollment_state[approvable] ||=
      if approvable.prerequisite_tree
        meets_prerequisites?(approvable.prerequisite_tree)
      else
        :yes
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

      if approved?(approvable_needed)
        :yes
      else
        if @stack.include?(approvable_needed)
          :not_yet
        else
          @stack.push(approvable_needed)
          state = enrollment_state(approvable_needed)
          @stack.pop

          if state == :never
            :never
          else
            :not_yet
          end
        end
      end
    when CreditsPrerequisite
      if credits(prerequisite_item.subject_group) >= prerequisite_item.credits_needed
        :yes
      else
        :not_yet
      end
    when LogicalPrerequisite
      if prerequisite_item.logical_operator == "and"
        states = prerequisite_item.operands_prerequisites.map do |prerequisite|
          meets_prerequisites?(prerequisite)
        end

        if states.include?(:never)
          :never
        elsif states.include?(:not_yet)
          :locked
        else
          :yes
        end
      elsif prerequisite_item.logical_operator == "or"
        states = prerequisite_item.operands_prerequisites.map do |prerequisite|
          meets_prerequisites?(prerequisite)
        end

        if states.include?(:yes)
          :yes
        elsif states.include?(:not_yet)
          :not_yet
        else
          :never
        end
      elsif prerequisite_item.logical_operator == "not"
        if meets_prerequisites?(prerequisite_item.operands_prerequisites[0]) == :yes
          :never
        else
          :yes
        end
      end
    end
  end

  def expire_enrollment_cache
    @enrollment_state = {}
  end
end
