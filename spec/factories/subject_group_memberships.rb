FactoryBot.define do
  factory :subject_group_membership do
    group { association :subject_group }
    credits { 5 }
  end
end
