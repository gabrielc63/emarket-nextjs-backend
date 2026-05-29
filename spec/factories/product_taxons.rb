FactoryBot.define do
  factory :product_taxon do
    association :product
    association :taxon
  end
end
