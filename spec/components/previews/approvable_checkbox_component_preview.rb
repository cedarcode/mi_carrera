class ApprovableCheckboxComponentPreview < ViewComponent::Preview
  def default
    approvable = FactoryBot.build_stubbed(:course)
    student = UserStudent.new(FactoryBot.build_stubbed(:user))

    render(ApprovableCheckboxComponent.new(approvable: approvable, subject_show: false, current_student: student))
  end
end
