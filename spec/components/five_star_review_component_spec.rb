# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FiveStarReviewComponent, type: :component do
  let(:subject_record) { create(:subject) }
  let(:user) { create(:user) }

  describe 'rendering' do
    context 'with basic props' do
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Test Rating",
          rating: 3.7
        )
      end

      it 'renders the review name' do
        render_inline(component)
        expect(page).to have_text("Test Rating")
      end

      it 'displays the rating with one decimal place' do
        render_inline(component)
        expect(page).to have_text("3.7")
      end

      it 'renders 5 star buttons' do
        render_inline(component)
        expect(page).to have_css('button', count: 5)
      end
    end

    context 'with nil rating' do
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Unknown Rating",
          rating: nil
        )
      end

      it 'displays dash for unknown rating' do
        render_inline(component)
        expect(page).to have_text("-.-")
      end
    end

    context 'with user review (3 stars)' do
      let(:user_review) { create(:review, user: user, subject: subject_record, rating: 3) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Rating",
          rating: 4.2,
          subject_id: subject_record.id,
          column_name: :rating,
          user_review: user_review
        )
      end

      it 'shows some filled and some outline stars' do
        render_inline(component)
        # Should have both filled and outline stars
        expect(page).to have_css('button', text: 'star')
        expect(page).to have_css('button', text: 'star_outline')
      end

      it 'applies different styling to filled and unfilled stars' do
        render_inline(component)
        # Should have both violet (filled) and gray (unfilled) stars
        expect(page).to have_css('button.text-violet-400')
        expect(page).to have_css('button.text-gray-400')
      end
    end

    context 'with user review (5 stars)' do
      let(:user_review) { create(:review, user: user, subject: subject_record, rating: 5) }
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Rating",
          rating: 4.8,
          subject_id: subject_record.id,
          column_name: :rating,
          user_review: user_review
        )
      end

      it 'shows all stars filled' do
        render_inline(component)
        expect(page).to have_css('button', text: 'star', count: 5)
        expect(page).not_to have_css('button', text: 'star_outline')
      end
    end

    context 'with no user review' do
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Rating",
          rating: 3.5,
          subject_id: subject_record.id,
          column_name: :rating,
          user_review: nil
        )
      end

      it 'shows all stars as outline' do
        render_inline(component)
        expect(page).to have_css('button', text: 'star_outline', count: 5)
      end

      it 'applies unselected styling to all stars' do
        render_inline(component)
        expect(page).to have_css('button.text-gray-400', count: 5)
        expect(page).not_to have_css('button.text-violet-400')
      end
    end

    context 'form attributes' do
      let(:component) do
        FiveStarReviewComponent.new(
          review_name: "Test",
          rating: 3.0,
          subject_id: subject_record.id,
          column_name: :rating
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

      it 'renders 5 forms (one per star)' do
        render_inline(component)
        expect(page).to have_css('form', count: 5)
      end
    end
  end

  describe 'helper methods' do
    let(:user_review) { create(:review, user: user, subject: subject_record, rating: 3) }
    let(:component) do
      FiveStarReviewComponent.new(
        review_name: "Test",
        rating: 4.2,
        subject_id: subject_record.id,
        column_name: :rating,
        user_review: user_review
      )
    end

    describe '#display_rating' do
      it 'formats rating with one decimal place' do
        expect(component.display_rating).to eq("4.2")
      end

      context 'with nil rating' do
        let(:component) { FiveStarReviewComponent.new(review_name: "Test", rating: nil) }

        it 'returns dash notation' do
          expect(component.display_rating).to eq("-.-")
        end
      end

      context 'with integer rating' do
        let(:component) { FiveStarReviewComponent.new(review_name: "Test", rating: 4) }

        it 'formats with one decimal place' do
          expect(component.display_rating).to eq("4.0")
        end
      end
    end

    describe '#star_options' do
      it 'returns array with 5 star options in descending order' do
        options = component.star_options
        expect(options.length).to eq(5)
        expect(options.map { |o| o[:value] }).to eq([5, 4, 3, 2, 1])
      end

      it 'includes all required keys for each option' do
        options = component.star_options
        options.each do |option|
          expect(option.keys).to include(:value, :filled, :selected, :icon, :color_class)
        end
      end

      context 'with 3-star user review' do
        it 'marks first 3 stars as filled' do
          options = component.star_options
          filled_values = options.select { |o| o[:filled] }.map { |o| o[:value] }
          expect(filled_values).to eq([3, 2, 1])
        end

        it 'marks only 3rd star as selected' do
          options = component.star_options
          selected_values = options.select { |o| o[:selected] }.map { |o| o[:value] }
          expect(selected_values).to eq([3])
        end

        it 'sets correct icons for filled and unfilled stars' do
          options = component.star_options
          filled_icons = options.select { |o| o[:filled] }.map { |o| o[:icon] }
          unfilled_icons = options.reject { |o| o[:filled] }.map { |o| o[:icon] }

          expect(filled_icons).to all(eq('star'))
          expect(unfilled_icons).to all(eq('star_outline'))
        end

        it 'sets correct color classes' do
          options = component.star_options
          filled_colors = options.select { |o| o[:filled] }.map { |o| o[:color_class] }
          unfilled_colors = options.reject { |o| o[:filled] }.map { |o| o[:color_class] }

          expect(filled_colors).to all(eq('text-violet-400'))
          expect(unfilled_colors).to all(eq('text-gray-400'))
        end
      end
    end

    describe '#hidden_field_value' do
      it 'returns nil for selected value (to deselect)' do
        expect(component.hidden_field_value(3)).to be_nil # 3 is selected
      end

      it 'returns the value for unselected values' do
        expect(component.hidden_field_value(1)).to eq(1)  # 1 is not selected (filled but not selected)
        expect(component.hidden_field_value(4)).to eq(4)  # 4 is not selected
        expect(component.hidden_field_value(5)).to eq(5)  # 5 is not selected
      end
    end
  end
end
