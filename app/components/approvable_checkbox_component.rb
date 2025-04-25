# frozen_string_literal: true

class ApprovableCheckboxComponent < ViewComponent::Base
  def initialize(approvable:, subject_show:, current_student:)
    @approvable = approvable
    @subject_show = subject_show
    @current_student = current_student
  end
end
