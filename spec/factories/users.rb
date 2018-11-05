FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { 'customer' }
    status { 'active' }
    after(:build) do |user|
      user.account ||= FactoryBot.build(:account, user: user)
    end

    factory :user_with_cards do
      after(:build) do |user|
        user.cards.build(FactoryBot.attributes_for(:card, issuer: "visa"))
        user.cards.build(FactoryBot.attributes_for(:card, issuer: "mastercard"))
      end
    end
  end
end
