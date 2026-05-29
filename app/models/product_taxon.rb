class ProductTaxon < ApplicationRecord
  belongs_to :product
  belongs_to :taxon

  validates :taxon_id, uniqueness: { scope: :product_id }
end
