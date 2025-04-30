# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
  attr_reader :approvable, :subject_show, :current_student

  def initialize(approvable:, subject_show:, current_student:)
    @approvable = approvable
    @subject_show = subject_show
    @current_student = current_student
  end
end
