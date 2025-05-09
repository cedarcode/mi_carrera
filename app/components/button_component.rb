# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(type:, disabled: false)
    @type = type
    @disabled = disabled
  end
end
