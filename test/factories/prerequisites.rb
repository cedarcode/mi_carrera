FactoryBot.define do
  factory :subject_prerequisite do
    approvable_needed factory: :course
  end

  factory :enrollment_prerequisite do
    approvable_needed factory: :course
  end

  factory :credits_prerequisite do
    credits_needed { 5 }
  end

  factory :logical_prerequisite do
    operands_prerequisites { nil }

    factory :and_prerequisite do
      logical_operator { "and" }
    end

    factory :or_prerequisite do
      logical_operator { "or" }
    end

    factory :not_prerequisite do
      logical_operator { "not" }
    end

    factory :at_least_prerequisite do
      logical_operator { "at_least" }
    end
  end

  factory :activity_prerequisite do
    approvable_needed factory: :exam
  end
end
