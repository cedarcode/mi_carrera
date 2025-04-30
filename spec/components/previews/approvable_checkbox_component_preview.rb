class ApprovableCheckboxComponentPreview < ViewComponent::Preview
  # @!group States

  def checked
    approvable = FactoryBot.build_stubbed(:course)
    student = UserStudent.new(FactoryBot.build_stubbed(:user, approvals: [approvable.id]))

    render(ApprovableCheckboxComponent.new(approvable: approvable, subject_show: false, current_student: student))
  end

  def unchecked
    approvable = FactoryBot.build_stubbed(:course)
    student = UserStudent.new(FactoryBot.build_stubbed(:user))

    render(ApprovableCheckboxComponent.new(approvable: approvable, subject_show: false, current_student: student))
  end

  def disabled
    approvable = FactoryBot.build_stubbed(:course, :with_prerequisites)
    student = UserStudent.new(FactoryBot.build_stubbed(:user))

    render(ApprovableCheckboxComponent.new(approvable: approvable, subject_show: false, current_student: student))
  end

  # @!endgroup
end
