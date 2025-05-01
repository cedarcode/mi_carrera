# frozen_string_literal: true

class NewPlannedSubjectComponent < ViewComponent::Base
  attr_reader :subjects

  def initialize(subjects:)
    @subjects = subjects
  end

  include SubjectsHelper
end
