class EmailFieldComponent < ViewComponent::Base
  STYLES = {
    input: %w[
      bg-white
      w-full
      rounded-md
      px-3
      py-1.5
      my-1

      outline-1
      outline-gray-300

      focus:outline-2
      focus:outline-indigo-600

      with-error:outline-red-500
      with-error:focus:outline-red-600
    ]
  }

  def initialize(form:, attribute:, label: nil, input_options: {})
    @form = form
    @attribute = attribute
    @label = label
    @input_options = input_options.merge(class: STYLES[:input])
  end

  private

  attr_reader :attribute, :form, :label, :input_options

  def error_messages
    return unless form.object.errors[attribute].any?

    form.object.errors[attribute].to_sentence.capitalize
  end
end
