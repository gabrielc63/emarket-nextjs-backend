FactoryBot.define do
  factory :wishlist do
    association :user
    sequence(:name) { |number| "Wishlist #{number}" }
  end
end
