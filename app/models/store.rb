class Store
  def initialize(store, current_user)
    @current_user = current_user
    @store = store
    @store[:approved_courses] ||= []
    @store[:approved_exams] ||= []
  end

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

  private

  attr_reader :current_user, :store

  def update_users_approvals
    current_user.approvals = store
    current_user.save!
  end
end
