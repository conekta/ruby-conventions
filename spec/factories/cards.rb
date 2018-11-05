FactoryBot.define do
  factory :card do
    last_4 { "1000" }
    card_type { "credit" }
    issuer { "visa" }
    status { "active" }
    expiration { 1.year.from_now.strftime("%Y/%m/%d") }
    association :user, factory: :user
    bank_token { Digest::MD5.hexdigest("supersecure") }
  end
end
