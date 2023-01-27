class Bedel
  def initialize(store, current_user = nil)
    @current_user = current_user
    @store = store
    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

  def add_approval(approvable)
    if able_to_do?(approvable)
      if approvable.is_exam?
        add_approved_exam(approvable.subject_id)
      else
        add_approved_course(approvable.subject_id)
      end
    else
      false
    end
  end

  def remove_approval(approvable)
    if approvable.is_exam?
      remove_approved_exam(approvable.subject_id)
    else
      remove_approved_course(approvable.subject_id)
    end

    refresh_approvals
  end

  def refresh_approvals
    subjects = TreePreloader.new.preload.index_by(&:id)

    loop do
      original_count = amount_of_approved_courses_and_exams

      approved_exams.each do |subject_id|
        approvable = subjects[subject_id].exam

        if !able_to_do?(approvable)
          remove_approved_exam(subject_id)
        end
      end

      approved_courses.each do |subject_id|
        approvable = subjects[subject_id].course

        if !able_to_do?(approvable)
          remove_approved_course(subject_id)
        end
      end

      new_count = amount_of_approved_courses_and_exams

      break if new_count == original_count
    end
  end

  def credits(group = nil)
    subjects = group ? group.subjects : Subject
    subjects.approved_credits(approved_courses, approved_exams)
  end

  def credits_by_group
    SubjectGroup.find_each.map do |subject_group|
      { subject_group: subject_group, credits: credits(subject_group) }
    end
  end

  def approved?(item)
    item.approved?(approved_courses, approved_exams)
  end

  def able_to_do?(item)
    item.available?(approved_courses, approved_exams)
  end

  private

  attr_reader :store, :current_user

  def add_approved_course(subject_id)
    store[:approved_courses] << subject_id
    update_users_approvals if current_user
  end

  def add_approved_exam(subject_id)
    store[:approved_exams] << subject_id
    update_users_approvals if current_user
  end

  def remove_approved_course(subject_id)
    store[:approved_courses].delete(subject_id)
    update_users_approvals if current_user
  end

  def remove_approved_exam(subject_id)
    store[:approved_exams].delete(subject_id)
    update_users_approvals if current_user
  end

  def approved_courses
    store[:approved_courses]
  end

  def approved_exams
    store[:approved_exams]
  end

  def amount_of_approved_courses_and_exams
    store[:approved_courses].size + store[:approved_exams].size
  end

  def update_users_approvals
    current_user.approvals = store
    current_user.save!
  end
end
