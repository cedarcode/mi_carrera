FactoryBot.define do
  factory :degree do
    sequence(:id) { |n| "testeneering_#{n}" }
    sequence(:name) { |n| "Testeneering #{n}" }
    current_plan { '2025' }
    include_inco_subjects { false }
  end
end
