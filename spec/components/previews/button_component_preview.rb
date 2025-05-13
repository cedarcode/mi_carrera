class ButtonComponentPreview < ViewComponent::Preview
  # @!group States

  def submit
    render(ButtonComponent.new(type: 'submit'))
  end

  def disabled
    render(ButtonComponent.new(type: 'submit', disabled: true))
  end

  # @!endgroup
end
