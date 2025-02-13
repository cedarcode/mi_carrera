class AppReview < ApplicationRecord
  belongs_to :user
  attr_accessor :user

  after_create :send_review_email

  def send_review_email
    AppReviewsNotifierMailer.notify_new_review(self).deliver_now
  end
end
