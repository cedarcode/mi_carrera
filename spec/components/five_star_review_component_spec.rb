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
          review_name: "Puntuación",
          rating_value: nil,
          subject_id:,
          column_name: :rating,
          user_review: nil
        )
      end

      it 'renders the review name' do
        render_inline(component)
        expect(page).to have_text("Puntuación")
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
          review_name: "Puntuación",
          rating_value: 4.22,
          subject_id:,
          column_name: :rating,
          user_review: nil
        )
      end

      it 'renders the rating value' do
        render_inline(component)
        expect(page).to have_text("4.2")
      end
    end

    context 'with user review' do
      let(:user_review) { create(:review, user:, subject: subject_record, rating: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Puntuación",
          rating_value: 4.2,
          subject_id:,
          column_name: :rating,
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
      let(:user_review) { create(:review, user:, subject: subject_record, rating: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Puntuación",
          rating_value: 4.2,
          subject_id:,
          column_name: :rating,
          user_review:
        )
      end

      it 'renders 5 forms' do
        render_inline(component)

        expect(page).to have_css('form[action="/reviews"]', count: 4)
        expect(page).to have_css("form[action=\"/reviews/#{user_review.id}\"]", count: 1)
      end

      it 'includes subject_id in all forms' do
        render_inline(component)

        expect(page).to have_field('subject_id', with: subject_id.to_s, type: 'hidden', count: 5)
      end

      it 'includes rating values 1 through 5' do
        render_inline(component)

        expect(page).to have_field('rating', with: '1', type: 'hidden', count: 1)
        expect(page).to have_field('rating', with: '2', type: 'hidden', count: 1)
        expect(page).to have_field('rating', with: '3', type: 'hidden', count: 1)
        expect(page).to have_field('rating', with: '4', type: 'hidden', count: 1)
        expect(page).to have_field('rating', with: '5', type: 'hidden', count: 1)
      end

      it 'uses DELETE method for current user rating' do
        render_inline(component)

        forms_with_delete = page.all('form').select do |form|
          form.has_field?('_method', with: 'delete', type: 'hidden')
        end
        expect(forms_with_delete.count).to eq(1)

        within(forms_with_delete.first) do
          expect(page).to have_field('rating', with: '3', type: 'hidden')
        end
      end

      it 'uses POST method for other ratings' do
        render_inline(component)

        [1, 2, 4, 5].each do |rating_value|
          form_with_rating = page.find("form:has(input[name='rating'][value='#{rating_value}'])")
          within(form_with_rating) do
            expect(page).not_to have_field('_method', type: 'hidden')
          end
        end
      end
    end
  end
end
