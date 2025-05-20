FactoryBot.define do
  factory :review do
    user
    subject
    rating { 3 }
    degree
  end
end
