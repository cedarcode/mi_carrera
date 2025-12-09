FactoryBot.define do
  factory :webauthn_credential do
    external_id { "MyString" }
    name { "MyString" }
    public_key { "MyText" }
    sign_count { 1 }
    user { nil }
    authentication_factor { 1 }
  end
end
