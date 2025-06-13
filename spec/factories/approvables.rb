FactoryBot.define do
  factory :approvable, aliases: [:course] do
    is_exam { false }
    subject

    trait :with_prerequisites do
      prerequisite_tree { association(:subject_prerequisite) }
    end

    factory :exam do
      is_exam { true }
    end
  end
end
