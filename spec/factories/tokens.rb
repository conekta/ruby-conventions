FactoryBot.define do
  factory :token do
    token_type { 'authentication' }
    association :user, factory: :user
  end
end
