# frozen_string_literal: true

class CheckboxComponent < ViewComponent::Base
  STYLES = {
    checkbox: %w[
      col-start-1
      row-start-1
      appearance-none
      rounded-sm
      border
      border-gray-300
      bg-white

      checked:border-primary
      checked:bg-primary

      focus-visible:outline-2
      focus-visible:outline-offset-0
      focus-visible:outline-primary

      disabled:border-gray-300
      disabled:bg-gray-100
      disabled:checked:bg-gray-100

      forced-colors:appearance-auto

      peer
    ],
    icon: %w[
      text-base/4!
      text-white
      pointer-events-none
      col-start-1
      row-start-1
      opacity-0
      peer-checked:opacity-100
      peer-disabled:text-gray-300
    ],
  }

  def initialize(*args, form:, extra_classes: [], **options)
    @args = args
    @form = form
    @extra_classes = extra_classes
    @options = options
  end

  private

  attr_reader :args, :form, :extra_classes, :options

  def checkbox_classes
    STYLES[:checkbox] + extra_classes
  end
end
