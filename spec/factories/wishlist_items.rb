FactoryBot.define do
  factory :wishlist_item do
    association :wishlist
    association :product
  end
end
