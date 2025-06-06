FactoryBot.define do
  factory :degree do
    title { 'Masters in Testeneering' }
    sequence(:name) { |n| "testeneering_#{n}" }
  end
end
