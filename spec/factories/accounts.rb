FactoryBot.define do
  factory :account do
    balance { 25000 }
    account_type { 'customer' }
    association :user, factory: :user
  end
end
