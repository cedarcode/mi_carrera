# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
  def initialize(approvable:, subject_show:, current_student:, filter_categories: Subject::MAIN_CATEGORIES)
    @approvable = approvable
    @subject_show = subject_show
    @current_student = current_student
    @filter_categories = filter_categories
  end

  private

  attr_reader :approvable, :subject_show, :current_student, :filter_categories

  def checked? = current_student.approved?(approvable)
  def disabled? = !current_student.available?(approvable) && !current_student.approved?(approvable)
end
