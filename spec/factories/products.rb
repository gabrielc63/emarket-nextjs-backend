FactoryBot.define do
  factory :product do
    sequence(:name) { |number| "Product #{number}" }
    sequence(:slug) { |number| "product-#{number}" }
    sequence(:sku) { |number| "SKU-#{number}" }
    description { "Marketplace product." }
    price_cents { 9_999 }
    currency { "USD" }
    stock_quantity { 10 }
    status { "active" }

    trait :draft do
      status { "draft" }
    end

    trait :archived do
      status { "archived" }
    end
  end
end
