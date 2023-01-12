class Bedel
  def initialize(store, user = nil)
    @store = store
    @user = user

    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

  def self.approvables_by_subject_id
    @@approvables_by_subject_id ||= Approvable.all.to_a.group_by(&:subject_id)
  end

  def self.approvables_by_id
    @@approvables_by_id ||= Approvable.all.to_a.index_by(&:id)
  end

  def self.prerequisites_by_approvable_id
    @@prerequisites_by_approvable_id ||= Prerequisite.all.to_a.index_by(&:approvable_id)
  end

  def self.prerequisites_group_by_parent_id
    @@prerequisites_group_by_parent_id ||= Prerequisite.all.to_a.group_by(&:parent_prerequisite_id)
  end

  def self.subjects_by_id
    @@subjects_by_id ||= Subject.all.to_a.index_by(&:id)
  end

  def self.reload_subjects
    @@approvables_by_subject_id = Approvable.all.to_a.group_by(&:subject_id)
    @@approvables_by_id = Approvable.all.to_a.index_by(&:id)
    @@prerequisites_by_approvable_id = Prerequisite.all.to_a.index_by(&:approvable_id)
    @@prerequisites_group_by_parent_id = Prerequisite.all.to_a.group_by(&:parent_prerequisite_id)
    @@subjects_by_id = Subject.all.to_a.index_by(&:id)
  end

  def add_approval(approvable)
    if able_to_do?(approvable)
      if approvable.is_exam?
        store[:approved_exams] += [approvable.subject_id]
      else
        store[:approved_courses] += [approvable.subject_id]
      end

      force_credits_recalculation!

      if @user
        @user.approvals = store
        @user.save!
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

    force_credits_recalculation!
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

    if @user
      @user.approvals = store
      @user.save!
    end

    if new_count != original_count
      force_credits_recalculation!
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
      prerequisite_tree = self.class.prerequisites_by_approvable_id[item.id]
      if prerequisite_tree
        meets_prerequisites?(prerequisite_tree)
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

  def force_credits_recalculation!
    @exam_credits = nil
    @course_credits = nil
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
      approvable_needed = self.class.approvables_by_id[prerequisite_item.approvable_needed_id]
      if approvable_needed.is_exam
        store[:approved_exams].include?(approvable_needed.subject_id)
      else
        store[:approved_courses].include?(approvable_needed.subject_id)
      end
    when CreditsPrerequisite
      credits(prerequisite_item.subject_group) >= prerequisite_item.credits_needed
    when LogicalPrerequisite
      operands = self.class.prerequisites_group_by_parent_id[prerequisite_item.id]
      if prerequisite_item.logical_operator == "and"
        operands.all? do |prerequisite|
          meets_prerequisites?(prerequisite)
        end
      elsif prerequisite_item.logical_operator == "or"
        operands.any? do |prerequisite|
          meets_prerequisites?(prerequisite)
        end
      elsif prerequisite_item.logical_operator == "not"
        operands.all? do |prerequisite|
          !meets_prerequisites?(prerequisite)
        end
      end
    end
  end
end
