# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
  STYLES = {
    checkbox_input: %w[
      appearance-none
      peer
      absolute
      size-full
      cursor-pointer
    ],
    checkbox: %w[
      size-4
      col-start-1
      row-start-1
      rounded-sm
      border
      border-gray-300
      bg-white
      pointer-events-none

      peer-checked:border-primary
      peer-checked:bg-primary

      peer-focus-visible:outline-2
      peer-focus-visible:outline-offset-0
      peer-focus-visible:outline-primary

      peer-disabled:border-gray-300
      peer-disabled:bg-gray-100
      peer-disabled:checked:bg-gray-100

      forced-colors:appearance-auto
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

  attr_reader :approvable, :subject_show, :current_student

  def initialize(approvable:, subject_show:, current_student:, disabled: nil)
    @approvable = approvable
    @subject_show = subject_show
    @current_student = current_student
    @disabled = disabled
  end

  private

  def checked? = current_student.approved?(approvable)

  def disabled?
    return @disabled unless @disabled.nil?

    !current_student.available?(approvable) && !current_student.approved?(approvable)
  end
end
