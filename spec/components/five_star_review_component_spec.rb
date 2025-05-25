# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FiveStarReviewComponent, type: :component do
  let(:subject_record) { create(:subject) }
  let(:subject_id) { subject_record.id }
  let(:user) { create(:user) }

  describe 'rendering' do
    context 'with nil rating_value' do
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Interesante",
          rating_value: nil,
          subject_id:,
          column_name: :interesting,
          user_review: nil
        )
      end

      it 'renders the review name' do
        render_inline(component)
        expect(page).to have_text("Interesante")
      end

      it 'displays dash for unknown value' do
        render_inline(component)
        expect(page).to have_text("-.-")
      end

      it 'shows unselected buttons' do
        render_inline(component)
        expect(page).to have_css('button.text-gray-400', text: 'star_outline', count: 5)
        expect(page).not_to have_css('button.text-violet-400')
      end
    end

    context 'with rating_value' do
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Interesante",
          rating_value: 4.22,
          subject_id:,
          column_name: :credits_to_difficulty_ratio,
          user_review: nil
        )
      end

      it 'renders the rating value' do
        render_inline(component)
        expect(page).to have_text("4.2")
      end
    end

    context 'with user review' do
      let(:user_review) { create(:review, user:, subject: subject_record, interesting: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Interesante",
          rating_value: 4.2,
          subject_id:,
          column_name: :interesting,
          user_review:
        )
      end

      it 'shows selected star and correct styling' do
        render_inline(component)
        expect(page).to have_css('button.text-violet-400', text: 'star', count: 3)
        expect(page).to have_css('button.text-gray-400', text: 'star_outline', count: 2)
      end
    end

    context 'form attributes' do
      let(:user_review) { create(:review, user:, subject: subject_record, credits_to_difficulty_ratio: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Interesante",
          rating_value: 4.2,
          subject_id:,
          column_name: :credits_to_difficulty_ratio,
          user_review:
        )
      end

      it 'posts to reviews_path with the correct parameters' do
        render_inline(component)

        expect(page).to have_css('form[action="/reviews"]', count: 5)
        expect(page).to have_css('form[method="post"]', count: 5)

        expect(page).to have_field('subject_id', with: subject_id.to_s, type: 'hidden', count: 5)
        expect(page).to have_field('credits_to_difficulty_ratio', type: 'hidden', count: 5)

        expect(page).to have_field('credits_to_difficulty_ratio', with: '1', type: 'hidden', count: 1)
        expect(page).to have_field('credits_to_difficulty_ratio', with: '2', type: 'hidden', count: 1)
        expect(page).to have_field('credits_to_difficulty_ratio', with: '4', type: 'hidden', count: 1)
        expect(page).to have_field('credits_to_difficulty_ratio', with: '5', type: 'hidden', count: 1)
        expect(page).not_to have_field('credits_to_difficulty_ratio', with: '3', type: 'hidden')
      end
    end
  end
end
