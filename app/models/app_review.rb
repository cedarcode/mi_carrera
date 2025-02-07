class AppReview < ApplicationRecord
  belongs_to :user
  attr_accessor :user
end
