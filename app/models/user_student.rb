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

  delegate :degree, to: :user

  private

  attr_reader :user

  def save!
    user.update!(approvals: approved_approvable_ids)
  end
end
