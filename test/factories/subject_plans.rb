FactoryBot.define do
  factory :subject_plan do
    user
    subject
    semester { 1 }
  end
end
