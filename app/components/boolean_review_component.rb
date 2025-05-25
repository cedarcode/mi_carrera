# frozen_string_literal: true

class BooleanReviewComponent < ViewComponent::Base
  attr_reader :review_name, :value, :subject_id, :column_name, :user_review

  def initialize(review_name:, value:, subject_id: nil, column_name: :value, user_review: nil)
    @review_name = review_name
    @value = value
    @subject_id = subject_id
    @column_name = column_name.to_sym
    @user_review = user_review
  end

  def display_value
    value.nil? ? '?' : "#{value.round(0)}%"
  end

  def vote_options
    [false, true].map do |val|
      {
        value: val,
        selected: selected?(val),
        should_destroy: should_destroy?(val),
        button_icon: button_icon(val),
        button_color: button_color(val),
        form_url: form_url(val),
        form_method: form_method(val)
      }
    end
  end

  private

  def selected?(val)
    !user_review&.send(column_name).nil? && user_review.send(column_name) == val
  end

  def should_destroy?(val)
    selected?(val) && user_review.all_review_fields_blank?(except: [column_name])
  end

  def button_icon(val)
    if selected?(val)
      val ? 'thumb_up' : 'thumb_down'
    else
      val ? 'thumb_up_off_alt' : 'thumb_down_off_alt'
    end
  end

  def button_color(val)
    selected?(val) ? 'text-violet-400' : 'text-gray-400'
  end

  def form_url(val)
    should_destroy?(val) ? review_path(user_review) : reviews_path
  end

  def form_method(val)
    should_destroy?(val) ? :delete : :post
  end

  def hidden_field_value(val)
    selected?(val) ? nil : val
  end
end 
