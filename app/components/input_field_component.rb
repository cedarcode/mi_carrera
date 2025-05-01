class InputFieldComponent < ViewComponent::Base
  attr_reader :attribute, :form, :label, :required, :type

  def initialize(form:, attribute:, label:, type: :text, required: false)
    @form = form
    @attribute = attribute
    @label = label
    @type = type.to_sym
    @required = required
  end

  def password?
    type == :password
  end

  def errors?
    form.object.errors[attribute].any?
  end

  def error_messages
    form.object.errors[attribute].join(', ').humanize
  end
end
