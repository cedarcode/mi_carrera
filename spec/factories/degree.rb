FactoryBot.define do
  factory :degree do
    title { 'Masters in Testeneering' }
    sequence(:name) { |n| "testeneering_#{n}" }
    current_plan { '2025' }
    include_inco_subjects { false }
  end
end
