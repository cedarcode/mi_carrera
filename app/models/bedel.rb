class Bedel
  def initialize(store, current_user = nil)
    @current_user = current_user
    @store = store
    @store[:approved_approvable_ids] ||= []
  end

  def add_approval(approvable)
    if able_to_do?(approvable)
      add_approved_approvable(approvable.id)
    else
      false
    end
  end

  def remove_approval(approvable)
    remove_approved_approvable(approvable.id)
    refresh_approvals
  end

  def refresh_approvals
    subjects = TreePreloader.new.preload
    approvables = subjects.flat_map { |subject| [subject.course, subject.exam].compact }
    approvables_by_id = approvables.index_by(&:id)

    loop do
      original_count = approved_approvable_ids.size

      approved_approvable_ids.each do |approvable_id|
        approvable = approvables_by_id[approvable_id]

        if !able_to_do?(approvable)
          remove_approved_approvable(approvable_id)
        end
      end

      new_count = approved_approvable_ids.size

      break if new_count == original_count
    end
  end

  def credits(group = nil)
    subjects = group ? group.subjects : Subject
    subjects.approved_credits(approved_approvable_ids)
  end

  def credits_by_group
    SubjectGroup.find_each.map do |subject_group|
      { subject_group: subject_group, credits: credits(subject_group) }
    end
  end

  def approved?(item)
    item.approved?(approved_approvable_ids)
  end

  def able_to_do?(item)
    item.available?(approved_approvable_ids)
  end

  private

  attr_reader :store, :current_user

  def add_approved_approvable(approvable_id)
    approved_approvable_ids << approvable_id
    update_users_approvals if current_user
  end

  def remove_approved_approvable(approvable_id)
    approved_approvable_ids.delete(approvable_id)
    update_users_approvals if current_user
  end

  def approved_approvable_ids
    store[:approved_approvable_ids]
  end

  def update_users_approvals
    current_user.approvals = store
    current_user.save!
  end
end
