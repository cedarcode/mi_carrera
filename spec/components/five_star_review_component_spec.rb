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
          rating_attribute: :interesting_rating,
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
          rating_attribute: :interesting_rating,
          user_review: nil
        )
      end

      it 'renders the rating value' do
        render_inline(component)
        expect(page).to have_text("4.2")
      end
    end

    context 'with user review' do
      let(:user_review) { create(:review, user:, subject: subject_record, interesting_rating: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Interesante",
          rating_value: 4.2,
          subject_id:,
          rating_attribute: :interesting_rating,
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
      let(:user_review) { create(:review, user:, subject: subject_record, interesting_rating: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Interesante",
          rating_value: 4.2,
          subject_id:,
          rating_attribute: :interesting_rating,
          user_review:
        )
      end

      it 'renders 5 forms' do
        render_inline(component)

        expect(page).to have_css('form[action="/reviews"]', count: 5)
      end

      it 'includes subject_id in all forms' do
        render_inline(component)

        expect(page).to have_field('subject_id', with: subject_id.to_s, type: 'hidden', count: 5)
      end

      it 'includes rating values 1 through 5, with nil for current rating' do
        render_inline(component)

        rating_values = page.all('input[name="interesting_rating"]', visible: false).map(&:value)

        expect(rating_values).to contain_exactly('1', '2', nil, '4', '5')
      end
    end
  end
end
