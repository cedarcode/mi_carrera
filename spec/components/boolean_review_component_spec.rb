# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooleanReviewComponent, type: :component do
  let(:subject_record) { create(:subject) }
  let(:user) { create(:user) }

  describe 'rendering' do
    context 'with basic props' do
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Test Review",
          value: 75.5
        )
      end

      it 'renders the review name' do
        render_inline(component)
        expect(page).to have_text("Test Review")
      end

      it 'displays the percentage value rounded' do
        render_inline(component)
        expect(page).to have_text("76%")
      end

      it 'renders both vote buttons' do
        render_inline(component)
        expect(page).to have_button("thumb_up_off_alt")
        expect(page).to have_button("thumb_down_off_alt")
      end
    end

    context 'with nil value' do
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Unknown Review",
          value: nil
        )
      end

      it 'displays question mark for unknown value' do
        render_inline(component)
        expect(page).to have_text("?")
      end
    end

    context 'with user review (positive)' do
      let(:user_review) { create(:review, user: user, subject: subject_record, recommended: true) }
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recommended",
          value: 85.0,
          subject_id: subject_record.id,
          column_name: :recommended,
          user_review: user_review
        )
      end

      it 'shows selected positive button' do
        render_inline(component)
        expect(page).to have_button("thumb_up")
        expect(page).to have_button("thumb_down_off_alt")
      end

      it 'applies selected styling to positive button' do
        render_inline(component)
        expect(page).to have_css('button.text-violet-400', text: 'thumb_up')
        expect(page).to have_css('button.text-gray-400', text: 'thumb_down_off_alt')
      end
    end

    context 'with user review (negative)' do
      let(:user_review) { create(:review, user: user, subject: subject_record, recommended: false) }
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recommended",
          value: 25.0,
          subject_id: subject_record.id,
          column_name: :recommended,
          user_review: user_review
        )
      end

      it 'shows selected negative button' do
        render_inline(component)
        expect(page).to have_button("thumb_up_off_alt")
        expect(page).to have_button("thumb_down")
      end

      it 'applies selected styling to negative button' do
        render_inline(component)
        expect(page).to have_css('button.text-gray-400', text: 'thumb_up_off_alt')
        expect(page).to have_css('button.text-violet-400', text: 'thumb_down')
      end
    end

    context 'with no user review' do
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recommended",
          value: 50.0,
          subject_id: subject_record.id,
          column_name: :recommended,
          user_review: nil
        )
      end

      it 'shows unselected buttons' do
        render_inline(component)
        expect(page).to have_button("thumb_up_off_alt")
        expect(page).to have_button("thumb_down_off_alt")
      end

      it 'applies unselected styling to both buttons' do
        render_inline(component)
        expect(page).to have_css('button.text-gray-400', text: 'thumb_up_off_alt')
        expect(page).to have_css('button.text-gray-400', text: 'thumb_down_off_alt')
      end
    end

    context 'form attributes' do
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Test",
          value: 50.0,
          subject_id: subject_record.id,
          column_name: :recommended
        )
      end

      it 'posts to reviews_path' do
        render_inline(component)
        expect(page).to have_css('form[action="/reviews"][method="post"]')
      end

      it 'includes subject_id in hidden field' do
        render_inline(component)
        expect(page).to have_field('subject_id', with: subject_record.id.to_s, type: 'hidden')
      end
    end
  end

  describe 'helper methods' do
    let(:user_review) { create(:review, user: user, subject: subject_record, recommended: true) }
    let(:component) do
      BooleanReviewComponent.new(
        review_name: "Test",
        value: 75.0,
        subject_id: subject_record.id,
        column_name: :recommended,
        user_review: user_review
      )
    end

    describe '#display_value' do
      it 'rounds percentage values' do
        expect(component.display_value).to eq("75%")
      end

      context 'with nil value' do
        let(:component) { BooleanReviewComponent.new(review_name: "Test", value: nil) }

        it 'returns question mark' do
          expect(component.display_value).to eq("?")
        end
      end
    end

    describe '#vote_options' do
      it 'returns array with false and true options' do
        options = component.vote_options
        expect(options.length).to eq(2)
        expect(options.map { |o| o[:value] }).to eq([false, true])
      end

      it 'includes all required keys for each option' do
        options = component.vote_options
        options.each do |option|
          expect(option.keys).to include(:value, :selected, :button_icon, :button_color)
        end
      end
    end

    describe '#hidden_field_value' do
      it 'returns nil for selected value (to deselect)' do
        expect(component.hidden_field_value(true)).to be_nil
      end

      it 'returns the value for unselected value' do
        expect(component.hidden_field_value(false)).to eq(false)
      end
    end
  end
end
