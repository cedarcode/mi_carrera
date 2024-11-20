# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Subjects", type: :system do
  let(:user) { create(:user) }
  let!(:subject_one) { create(:subject, name: "Algebra I", short_name: "GAL", code: "1010") }
  let!(:subject_two) { create(:subject, name: "Calculus I", short_name: "CDIV", code: "1020") }

  before do
    # https://github.com/heartcombo/devise/issues/5705
    Rails.application.reload_routes_unless_loaded
  end

  before do
    sign_in user
  end

  describe "visiting the subjects index" do
    it "displays all subjects" do
      visit subjects_path

      expect(page).to have_content("GAL")
      expect(page).to have_content("CDIV")
    end

    context "when a subject is hidden" do
      before do
        subject_one.update(category: :inactive)
      end

      it "is not displayed" do
        visit subjects_path

        expect(page).not_to have_content("GAL")
        expect(page).to have_content("CDIV")
      end

      it "is displayed if the student has approved it" do
        user.approvals.push(subject_one.course.id)

        visit subjects_path

        expect(page).to have_content("GAL")
        expect(page).to have_content("CDIV")
      end
    end
  end

  describe "viewing a subject" do
    it "displays the correct subject details" do
      visit subject_path(subject_one)

      expect(page).to have_content("Algebra I")
      expect(page).to have_content("1010")
    end
  end

  describe "searching for subjects" do
    it "displays all subjects when no search params are present" do
      visit all_subjects_path

      expect(page).to have_content("GAL")
      expect(page).to have_content("CDIV")
    end

    it "displays subjects based on search params 'name'" do
      visit all_subjects_path(search: "Algebra I")

      expect(page).to have_content("GAL")
      expect(page).not_to have_content("CDIV")
    end

    it "displays subjects based on search params 'short_name'" do
      visit all_subjects_path(search: "CDIV")

      expect(page).to have_content("CDIV")
      expect(page).not_to have_content("GAL")
    end

    it "displays subjects based on search params 'code'" do
      visit all_subjects_path(search: "1020")

      expect(page).to have_content("CDIV")
      expect(page).not_to have_content("GAL")
    end
  end
end
