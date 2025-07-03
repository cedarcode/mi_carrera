class BaseStudent
  def initialize(approved_approvable_ids)
    @approved_approvable_ids = approved_approvable_ids
  end

  def add(approvable)
    if ids.exclude?(approvable.id) && approvable.available?(self)
      ids << approvable.id
      add(approvable.subject.course) if approvable.is_exam?
      update_credits(approvable.subject.group)
      save!
    end
  end

  def force_add_subject(subject)
    ids << subject.exam.id if subject.exam && !ids.include?(subject.exam.id)
    ids << subject.course.id if subject.course && !ids.include?(subject.course.id)
    update_credits(subject.group)
    save!
  end

  def remove(approvable)
    ids.delete(approvable.id)
    if !approvable.is_exam? && approvable.subject.exam.present? && ids.include?(approvable.subject.exam.id)
      ids.delete(approvable.subject.exam.id)
    end
    update_credits(approvable.subject.group)
    save!
  end

  def available?(subject_or_approvable) = subject_or_approvable.available?(self)
  def approved?(subject_or_approvable) = subject_or_approvable.approved?(self)
  def met?(prerequisite) = prerequisite.met?(self)
  def group_credits_met?(group) = group_credits[group.id].to_i >= group.credits_needed
  def groups_credits_met? = SubjectGroup.all.all? { |group| group_credits_met?(group) }
  def graduated? = total_credits >= 450 && groups_credits_met?
  def banner_viewed?(_) = raise NoMethodError
  def mark_banner_as_viewed!(_) = raise NoMethodError

  attr_reader :approved_approvable_ids
  alias_method :ids, :approved_approvable_ids

  private

  def save!
    raise NotImplementedError
  end

  def update_credits(group)
    self.total_credits = Subject.approved_credits(ids)
    return unless group

    group_credits[group.id] = group.subjects.approved_credits(ids)
  end
end
