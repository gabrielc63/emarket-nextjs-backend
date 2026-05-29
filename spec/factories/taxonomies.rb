FactoryBot.define do
  factory :taxonomy do
    sequence(:name) { |number| "Taxonomy #{number}" }
    sequence(:slug) { |number| "taxonomy-#{number}" }
  end
end
