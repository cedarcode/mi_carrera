class TextFieldComponent < ViewComponent::Base
  renders_one :trailing_icon
  renders_one :hint

  attr_reader :attribute, :container_options, :form, :input_options, :label, :type

  def initialize(form:, attribute:, label:, type: :text, container_options: {}, input_options: {})
    @form = form
    @attribute = attribute
    @label = label
    @type = type.to_sym
    @container_options = container_options
    @input_options = input_options
  end

  def errors?
    form.object.errors[attribute].any?
  end

  def error_messages
    form.object.errors[attribute].join(', ').humanize
  end
end
