class PasswordFieldComponent < ViewComponent::Base
  STYLES = {
    input: %w[
      bg-white
      w-full
      rounded-md
      px-3
      py-1.5

      outline-1
      outline-gray-300

      focus:outline-2
      focus:outline-indigo-600

      with-error:outline-red-500
      with-error:focus:outline-red-600
    ],
    icon: %w[
      flex
      items-center

      absolute
      inset-y-0
      right-0
      pr-3

      cursor-pointer
      hover:text-indigo-700
    ]
  }

  attr_reader :form, :attribute, :label, :hint, :input_options

  def initialize(form:, attribute:, label: nil, hint: nil, input_options: {})
    @form = form
    @attribute = attribute
    @label = label
    @hint = hint
    @input_options = input_options.merge(class: STYLES[:input], data: { show_password_target: "password" })
  end

  def error_messages
    return unless form.object.errors[attribute].any?

    form.object.errors[attribute].to_sentence.capitalize
  end
end
