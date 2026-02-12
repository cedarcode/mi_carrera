FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "S3cr3tP@ssw0rd!" }
    degree_id { ActiveRecord::FixtureSet.identify(:computacion) }
    degree_plan_id { ActiveRecord::FixtureSet.identify(:computacion_active_plan) }
  end
end
