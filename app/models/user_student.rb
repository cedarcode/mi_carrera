class UserStudent < BaseStudent
  def initialize(user)
    super(user.approvals || [])
    @user = user
  end

  private

  attr_reader :user

  def save!
    user.update!(approvals: approved_approvable_ids)
  end
end
