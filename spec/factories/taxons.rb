FactoryBot.define do
  factory :taxon do
    association :taxonomy
    sequence(:name) { |number| "Taxon #{number}" }
    sequence(:slug) { |number| "taxon-#{number}" }
    position { 0 }
  end
end
