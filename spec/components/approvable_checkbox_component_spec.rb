# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApprovableCheckboxComponent, type: :component do
  context 'when subject is already approved' do
    it "renders the checkbox with checked status" do
      approvable = FactoryBot.build_stubbed(:course)
      student = UserStudent.new(FactoryBot.build_stubbed(:user, approvals: [approvable.id]))

      render_inline(described_class.new(approvable: approvable, subject_show: false, current_student: student))

      expect(page).to have_css "form[action='/approvables/#{approvable.id}/approval?subject_show=false']"
      expect(page).to have_css "input[name='_method'][value='delete']", visible: false
      expect(page).to have_css "input[type='checkbox'][name='approvable[approved]'][checked]"
      expect(page).to have_css "svg"
    end
  end

  context 'when subject is available' do
    it "renders the checkbox with unchecked status" do
      approvable = FactoryBot.build_stubbed(:course)
      student = UserStudent.new(FactoryBot.build_stubbed(:user))

      render_inline(described_class.new(approvable: approvable, subject_show: false, current_student: student))

      expect(page).to have_css "form[action='/approvables/#{approvable.id}/approval?subject_show=false'][method='post']"
      expect(page).to have_css "input[type='checkbox'][name='approvable[approved]']"
      expect(page).to have_css "svg"
    end
  end

  context 'when subject is not available' do
    it "renders the checkbox with disabled status" do
      approvable = FactoryBot.build_stubbed(:course, :with_prerequisites)
      student = UserStudent.new(FactoryBot.build_stubbed(:user))

      render_inline(described_class.new(approvable: approvable, subject_show: false, current_student: student))

      expect(page).to have_css "form[action='/approvables/#{approvable.id}/approval?subject_show=false'][method='post']"
      expect(page).to have_css "input[type='checkbox'][name='approvable[approved]'][disabled]"
      expect(page).to have_css "svg"
    end
  end
end
