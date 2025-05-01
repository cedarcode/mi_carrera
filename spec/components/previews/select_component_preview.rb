class SelectComponentPreview < ViewComponent::Preview
  # @!group States

  def with_options
    form = ActionView::Helpers::FormBuilder.new(:model, nil, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
    options = [
      ["Option 1", 1],
      ["Option 2", 2],
      ["Option 3", 3]
    ]

    render(SelectComponent.new(form: form, field: :field_name, options: options))
  end

  def with_custom_classes
    form = ActionView::Helpers::FormBuilder.new(:model, nil, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
    options = [
      ["Option 1", 1],
      ["Option 2", 2]
    ]

    render(SelectComponent.new(
      form: form,
      field: :field_name,
      options: options,
      html_options: { class: "w-64" }
    ))
  end

  def with_data_attributes
    form = ActionView::Helpers::FormBuilder.new(:model, nil, ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil), {})
    options = [
      ["Option 1", 1],
      ["Option 2", 2]
    ]

    render(SelectComponent.new(
      form: form,
      field: :field_name,
      options: options,
      html_options: { data: { controller: "example" } }
    ))
  end

  # @!endgroup
end
