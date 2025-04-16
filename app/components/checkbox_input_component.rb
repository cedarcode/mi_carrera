# frozen_string_literal: true

class CheckboxInputComponent < ViewComponent::Base
  def initialize(*args)
    options = args.extract_options!
    options[:class] = [options[:class], default_input_classes].compact.join(' ')
    @input_params = args << options
  end

  private

  def default_input_classes
    [
      'col-start-1',
      'row-start-1',
      'appearance-none',
      'rounded-sm',
      'border',
      'border-gray-300',
      'bg-white',
      'checked:border-indigo-600',
      'checked:bg-indigo-600',
      'indeterminate:border-indigo-600',
      'indeterminate:bg-indigo-600',
      'focus-visible:outline-2',
      'focus-visible:outline-offset-0',
      'focus-visible:outline-indigo-600',
      'disabled:border-gray-300',
      'disabled:bg-gray-100',
      'disabled:checked:bg-gray-100',
      'forced-colors:appearance-auto',
    ].join(' ')
  end
end
