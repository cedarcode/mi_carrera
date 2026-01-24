class BaseStudent
  attr_reader :approved_approvable_ids

  def initialize(approved_approvable_ids)
    @approved_approvable_ids = approved_approvable_ids
  end

  def add(approvable)
    if ids.exclude?(approvable.id) && approvable.available?(ids)
      ids << approvable.id
      add(approvable.subject.course) if approvable.is_exam?
      save!
    end
  end

  def force_add_subject(subject)
    ids << subject.exam.id if subject.exam && !ids.include?(subject.exam.id)
    ids << subject.course.id if subject.course && !ids.include?(subject.course.id)
    save!
  end

  def remove(approvable)
    ids.delete(approvable.id)
    if !approvable.is_exam? && approvable.subject.exam.present? && ids.include?(approvable.subject.exam.id)
      ids.delete(approvable.subject.exam.id)
    end
    save!
  end

  def available?(subject_or_approvable) = subject_or_approvable.available?(ids)
  def approved?(subject_or_approvable) = subject_or_approvable.approved?(ids)
  def group_credits(group) = group.subjects.approved_credits(ids)
  def total_credits = degree.subjects.approved_credits(ids)
  def met?(prerequisite) = prerequisite.met?(ids)
  def group_credits_met?(group) = group_credits(group) >= group.credits_needed
  def groups_credits_met? = degree.subject_groups.all? { |group| group_credits_met?(group) }
  def graduated? = total_credits >= 450 && groups_credits_met?
  def banner_viewed?(_) = raise NoMethodError
  def mark_banner_as_viewed!(_) = raise NoMethodError
  def approved_subjects = degree.subjects.approved_for(ids)

  private

  alias_method :ids, :approved_approvable_ids

  def save!
    raise NotImplementedError
  end
end
