FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "S3cr3tP@ssw0rd!" }
    degree { create :degree }
  end
end
