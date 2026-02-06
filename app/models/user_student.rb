class UserStudent < BaseStudent
  def initialize(user)
    super(user.approvals || [])
    @user = user
  end

  def mark_banner_as_viewed!(banner_type)
    user.update!("#{banner_type}_banner_viewed" => true)
  end

  def banner_viewed?(banner_type)
    user.public_send("#{banner_type}_banner_viewed?")
  end

  delegate :degree, :degree_id, :degree=, to: :user

  def save
    user.update(approvals: approved_approvable_ids)
  end

  def save!
    user.update!(approvals: approved_approvable_ids)
  end

  private

  attr_reader :user
end
