class PasswordFieldComponent < ViewComponent::Base
  renders_one :hint

  attr_reader :attribute, :form, :label, :container_options, :input_options

  def initialize(form:, attribute:, label:, container_options: {}, input_options: {})
    @form = form
    @attribute = attribute
    @label = label
    @container_options = container_options
    @input_options = input_options
  end

  def call
    render TextFieldComponent.new(
      form: form,
      attribute: attribute,
      label: label,
      type: :password,
      container_options: container_options.merge(data: { controller: "show-password" }),
      input_options: input_options.merge(data: { show_password_target: "password" })
    ) do |component|
      component.with_hint do
        hint.to_s if hint.present?
      end

      component.with_trailing_icon do
        render "shared/password_visibility_button"
      end
    end
  end
end
