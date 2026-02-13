FactoryBot.define do
  factory :subject_group, aliases: [:group] do
    sequence(:code) { |n| "GROUP-#{n}" }
    sequence(:name) { |n| "Subject Group #{n}" }
    degree_plan
  end
end
