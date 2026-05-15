FactoryBot.define do
  factory :degree_plan do
    sequence(:name) { |n| "Degree Plan #{n}" }
    degree
  end
end
