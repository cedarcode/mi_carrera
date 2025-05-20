FactoryBot.define do
  factory :degree do
    name { 'Masters in Testeneering' }
    sequence(:key) { |n| "testeneering_#{n}" }
  end
end
