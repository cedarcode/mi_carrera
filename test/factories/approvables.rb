FactoryBot.define do
  factory :course, class: "Approvable" do
    is_exam { false }
    subject
  end

  factory :exam, class: "Approvable" do
    is_exam { true }
    subject
  end
end
