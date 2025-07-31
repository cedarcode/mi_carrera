FactoryBot.define do
  factory :degree do
    sequence(:id) { |n| "testeneering_#{n}" }
    current_plan { '2025' }
  end
end
