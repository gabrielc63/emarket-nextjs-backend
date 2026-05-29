require "rails_helper"

RSpec.describe ProductTaxon, type: :model do
  it "prevents duplicate product taxon assignments" do
    product = create(:product)
    taxon = create(:taxon)

    create(:product_taxon, product: product, taxon: taxon)
    duplicate = build(:product_taxon, product: product, taxon: taxon)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:taxon_id]).to include("has already been taken")
  end
end
