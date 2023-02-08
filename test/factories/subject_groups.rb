FactoryBot.define do
  factory :subject_group, aliases: [:group] do
    sequence(:code) { |n| "GROUP-#{n}" }
    sequence(:name) { |n| "Subject Group #{n}" }
  end
end
