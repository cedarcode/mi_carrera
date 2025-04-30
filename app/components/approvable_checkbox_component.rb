# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
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
