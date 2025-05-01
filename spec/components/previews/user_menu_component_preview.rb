class UserMenuComponentPreview < ViewComponent::Preview
  # @!group States

  def with_user
    user = FactoryBot.build_stubbed(:user)
    render(UserMenuComponent.new(current_user: user))
  end

  def without_user
    render(UserMenuComponent.new(current_user: nil))
  end

  # @!endgroup
end
