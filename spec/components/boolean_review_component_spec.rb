# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooleanReviewComponent, type: :component do
  let(:subject_record) { create(:subject) }
  let(:subject_id) { subject_record.id }
  let(:user) { create(:user) }

  describe 'rendering' do
    context 'with nil rating_value' do
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recomendado",
          rating_value: nil,
          subject_id:,
          column_name: :recommended,
          user_review: nil
        )
      end

      it 'renders the review name' do
        render_inline(component)
        expect(page).to have_text("Recomendado")
      end

      it 'displays question mark for unknown value' do
        render_inline(component)
        expect(page).to have_text("?")
      end

      it 'shows unselected buttons' do
        render_inline(component)
        expect(page).to have_css('button.text-gray-400', text: 'thumb_up_off_alt')
        expect(page).to have_css('button.text-gray-400', text: 'thumb_down_off_alt')
      end
    end

    context 'with rating_value' do
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recomendado",
          rating_value: 50.0,
          subject_id:,
          column_name: :recommended,
          user_review: nil
        )
      end

      it 'renders the rating value' do
        render_inline(component)
        expect(page).to have_text("50%")
      end
    end

    context 'with user review (positive)' do
      let(:user_review) { create(:review, user:, subject: subject_record, recommended: true) }
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recomendado",
          rating_value: 85.0,
          subject_id:,
          column_name: :recommended,
          user_review:
        )
      end

      it 'shows selected positive button' do
        render_inline(component)
        expect(page).to have_css('button.text-violet-400', text: 'thumb_up')
        expect(page).to have_css('button.text-gray-400', text: 'thumb_down_off_alt')
      end
    end

    context 'with user review (negative)' do
      let(:user_review) { create(:review, user:, subject: subject_record, recommended: false) }
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recomendado",
          rating_value: 25.0,
          subject_id:,
          column_name: :recommended,
          user_review:
        )
      end

      it 'shows selected negative button' do
        render_inline(component)
        expect(page).to have_css('button.text-gray-400', text: 'thumb_up_off_alt')
        expect(page).to have_css('button.text-violet-400', text: 'thumb_down')
      end
    end

    context 'form attributes' do
      let(:user_review) { create(:review, user:, subject: subject_record, recommended: true) }
      let(:component) do
        BooleanReviewComponent.new(
          review_name: "Recomendado",
          rating_value: 50.0,
          subject_id:,
          column_name: :recommended,
          user_review:
        )
      end

      it 'posts to reviews_path with the correct parameters' do
        render_inline(component)

        expect(page).to have_css('form[action="/reviews"]', count: 2)
        expect(page).to have_css('form[method="post"]', count: 2)

        expect(page).to have_field('subject_id', with: subject_id.to_s, type: 'hidden', count: 2)
        expect(page).to have_field('recommended', type: 'hidden', count: 2)

        expect(page).to have_field('recommended', with: 'false', type: 'hidden')
        expect(page).not_to have_field('recommended', with: 'true', type: 'hidden')
      end
    end
  end
end
