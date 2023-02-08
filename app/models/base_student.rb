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

  def remove(approvable)
    ids.delete(approvable.id)
    refresh_approvals
    save!
  end

  def available?(subject_or_approvable) = subject_or_approvable.available?(ids)
  def approved?(subject_or_approvable) = subject_or_approvable.approved?(ids)
  def group_credits(group) = group.subjects.approved_credits(ids)
  def total_credits = Subject.approved_credits(ids)

  private

  attr_reader :approved_approvable_ids
  alias_method :ids, :approved_approvable_ids

  def save!
    raise NotImplementedError
  end

  def refresh_approvals
    approvables = TreePreloader.new.preload.flat_map { |subject| [subject.course, subject.exam].compact }
    approvables_by_id = approvables.index_by(&:id)

    loop do
      rejected = ids.reject! { |id| !approvables_by_id[id].available?(ids) }

      break unless rejected
    end
  end
end
