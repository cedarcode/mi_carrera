class BaseStudent
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
  def total_credits = Subject.approved_credits(ids)
  def welcome_banner_viewed? = raise NotImplementedError
  def welcome_banner_mark_as_viewed! = raise NotImplementedError
  def met?(prerequisite) = prerequisite.met?(ids)
  def group_credits_met?(group) = group_credits(group) >= group.credits_needed
  def groups_credits_met? = SubjectGroup.all.all? { |group| group_credits_met?(group) }
  def graduated? = total_credits >= 450 && groups_credits_met?
  def planner_banner_viewed? = raise NotImplementedError
  def planner_banner_mark_as_viewed! = raise NotImplementedError

  private

  attr_reader :approved_approvable_ids
  alias_method :ids, :approved_approvable_ids

  def save!
    raise NotImplementedError
  end
end
