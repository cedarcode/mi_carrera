class UserStudent < BaseStudent
  def initialize(user)
    super(user.approvals || [])
    @user = user
  end

  def welcome_banner_viewed?
    user.welcome_banner_viewed
  end

  def welcome_banner_mark_as_viewed!
    user.update!(welcome_banner_viewed: true)
  end

  def planner_banner_viewed?
    user.planner_banner_viewed
  end

  def planner_banner_mark_as_viewed!
    user.update!(planner_banner_viewed: true)
  end

  delegate :degree, to: :user

  private

  attr_reader :user

  def save!
    user.update!(approvals: approved_approvable_ids)
  end
end
