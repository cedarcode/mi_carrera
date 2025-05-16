class NewPlannedSubjectComponentPreview < ViewComponent::Preview
  # @!group States

  def with_subjects
    subjects = [
      FactoryBot.build_stubbed(:subject, name: "GAL 1", code: "1030"),
      FactoryBot.build_stubbed(:subject, name: "GAL 2", code: "1031"),
      FactoryBot.build_stubbed(:subject, name: "Taller", code: "1032")
    ]

    render(NewPlannedSubjectComponent.new(subjects: subjects))
  end

  def with_empty_subjects
    render(NewPlannedSubjectComponent.new(subjects: []))
  end

  # @!endgroup
end
