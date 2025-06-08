# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
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
      md-16
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

  def initialize(approvable:, subject_show:, current_student:)
    @approvable = approvable
    @subject_show = subject_show
    @current_student = current_student
  end

  private

  def checked? = current_student.approved?(approvable)

  def disabled? = !current_student.available?(approvable) && !current_student.approved?(approvable)
end
