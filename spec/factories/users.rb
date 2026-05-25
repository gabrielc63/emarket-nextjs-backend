FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |number| "user-#{number}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "customer" }

    trait :seller do
      role { "seller" }
    end

    trait :admin do
      role { "admin" }
    end
  end
end
