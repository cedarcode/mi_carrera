FactoryBot.define do
  factory :subject do
    sequence(:code) { |n| "SUBJECT-#{n}" }
    sequence(:name) { |n| "Subject #{n}" }
    credits { 5 }
    category { 'first_semester' }
    group
    degree_id { "computacion" }
    course { association :course, subject: instance, strategy: :build }
    degree_plan { association :degree_plan, degree: degree }

    trait :with_exam do
      exam { association :exam, subject: instance, strategy: :build }
    end

    trait :inactive do
      category { 'inactive' }
    end
  end
end
