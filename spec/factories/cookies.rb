FactoryBot.define do
  factory :cookie, class: "ActionDispatch::Cookies::CookieJar" do
    transient do
      welcome_banner_viewed { nil }
      approved_approvable_ids { nil }
      degree_id { nil }
    end

    initialize_with do
      cookies = {}
      cookies[:approved_approvable_ids] = approved_approvable_ids.to_json if approved_approvable_ids
      cookies[:welcome_banner_viewed] = welcome_banner_viewed.to_json unless welcome_banner_viewed.nil?
      cookies[:degree_id] = degree_id if degree_id.present?

      ActionDispatch::Cookies::CookieJar.build(ActionDispatch::Request.empty, cookies)
    end
  end
end
