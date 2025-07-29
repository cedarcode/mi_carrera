# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
  STYLES = {
    checkbox: %w[
      appearance-none
      peer
      absolute
      size-full
      cursor-pointer
    ],
    visual_checkbox: %w[
      size-4
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
      absolute
      opacity-0
      peer-checked:opacity-100
      peer-disabled:text-gray-300
    ],
  }

  attr_reader :approvable, :subject_show, :current_student

  def initialize(approvable:, subject_show:, current_student:)
    @approvable = approvable
    @subject_show = subject_show
    @current_student = current_student
  end

  private

  def checked? = current_student.approved?(approvable)

  def disabled? = !current_student.available?(approvable) && !current_student.approved?(approvable)
end
