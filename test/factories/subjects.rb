FactoryBot.define do
  factory :subject do
    sequence(:code) { |n| "SUBJECT-#{n}" }
    sequence(:name) { |n| "Subject #{n}" }
    credits { 5 }
    semester { 1 }
    group
    course { association :course, subject: instance }

    trait :with_exam do
      exam { association :exam, subject: instance }
    end
  end
end
