# frozen_string_literal: true

class SubjectWithCheckboxesComponent < ViewComponent::Base
  include SubjectsHelper

  with_collection_parameter :subject

  def initialize(subject:, current_student:)
    @subject = subject
    @current_student = current_student
  end
end
