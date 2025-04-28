class CheckboxInputComponentPreview < ViewComponent::Preview
  # @!group States

  def checked
    render(CheckboxInputComponent.new('test', checked: true))
  end

  def unchecked
    render(CheckboxInputComponent.new('test', checked: false))
  end

  def disabled
    render(CheckboxInputComponent.new('test', disabled: true))
  end

  # @!endgroup
end
