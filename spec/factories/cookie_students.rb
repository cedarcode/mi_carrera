FactoryBot.define do
  factory :cookie_student do
    transient do
      welcome_banner_viewed { nil }
      approved_approvable_ids { nil }
      degree_id { nil }
      cookies { build(:cookie, welcome_banner_viewed:, approved_approvable_ids:, degree_id:) }
    end

    initialize_with do
      new(cookies)
    end
  end
end
