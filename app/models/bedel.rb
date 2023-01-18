class Bedel
  def initialize(store, user = nil)
    @store = store
    @user = user

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

    if @user
      @user.approvals = store
      @user.save!
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

    if @user
      @user.approvals = store
      @user.save!
    end

    if new_count != original_count
      refresh_approvals
    end
  end

  def credits(group = nil)
    subjects = group ? group.subjects : Subject

    # @credits ||= {}
    # @credits[group&.id] ||= subjects.approved_credits(store[:approved_courses], store[:approved_exams])
    subjects.approved_credits(store[:approved_courses], store[:approved_exams])
  end

  def credits_by_group
    SubjectGroup.find_each.map do |subject_group|
      { subject_group: subject_group, credits: credits(subject_group) }
    end
  end

  def approved?(item)
    item.approved?(store[:approved_courses], store[:approved_exams])
  end

  def able_to_do?(item)
    item.available?(store[:approved_courses], store[:approved_exams])
  end

  private

  attr_reader :store
end
