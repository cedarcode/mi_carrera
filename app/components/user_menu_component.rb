# frozen_string_literal: true

class UserMenuComponent < ViewComponent::Base
  attr_reader :current_user

  def initialize(current_user:)
    @current_user = current_user
  end
end
