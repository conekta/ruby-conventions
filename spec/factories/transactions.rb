FactoryBot.define do
  factory :transaction do
    amount { 150 }
    transaction_type { 'transfer' }
    association :transferable, factory: :account
    transferable_balance { 150 }
    association :user, factory: :user
    user_balance { 1350 }
    description { "A test transaction" }

    trait :with_reference do
      association :reference, factory: :transaction
    end
  end
end
