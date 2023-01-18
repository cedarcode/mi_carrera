class Bedel
  def initialize(session, current_user = nil)
    @store = Store.new(session, current_user)
  end

  def add_approval(approvable)
    if able_to_do?(approvable)
      if approvable.is_exam?
        store.add_approved_exam(approvable.subject_id)
      else
        store.add_approved_course(approvable.subject_id)
      end
    else
      false
    end
  end

  def remove_approval(approvable)
    if approvable.is_exam?
      store.remove_approved_exam(approvable.subject_id)
    else
      store.remove_approved_course(approvable.subject_id)
    end

    refresh_approvals
  end

  def refresh_approvals
    subjects = TreePreloader.new.preload.index_by(&:id)

    loop do
      original_count = store.amount_of_approved_courses_and_exams

      store.approved_exams.each do |subject_id|
        approvable = subjects[subject_id].exam

        if !able_to_do?(approvable)
          store.remove_approved_exam(subject_id)
        end
      end

      store.approved_courses.each do |subject_id|
        approvable = subjects[subject_id].course

        if !able_to_do?(approvable)
          store.remove_approved_course(subject_id)
        end
      end

      new_count = store.amount_of_approved_courses_and_exams

      break if new_count == original_count
    end
  end

  def credits(group = nil)
    subjects = group ? group.subjects : Subject
    subjects.approved_credits(store.approved_courses, store.approved_exams)
  end

  def credits_by_group
    SubjectGroup.find_each.map do |subject_group|
      { subject_group: subject_group, credits: credits(subject_group) }
    end
  end

  def approved?(item)
    item.approved?(store.approved_courses, store.approved_exams)
  end

  def able_to_do?(item)
    item.available?(store.approved_courses, store.approved_exams)
  end

  private

  attr_reader :store
end
