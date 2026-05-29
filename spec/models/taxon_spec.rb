require "rails_helper"

RSpec.describe Taxon, type: :model do
  it "generates a nested slug from the parent" do
    taxonomy = create(:taxonomy, name: "Categories", slug: "categories")
    parent = create(:taxon, taxonomy: taxonomy, name: "Electronics", slug: "electronics")
    child = build(:taxon, taxonomy: taxonomy, parent: parent, name: "Headphones", slug: nil)

    expect(child).to be_valid
    expect(child.slug).to eq("electronics-headphones")
  end

  it "requires parent to belong to the same taxonomy" do
    parent = create(:taxon)
    child = build(:taxon, parent: parent)

    expect(child).not_to be_valid
    expect(child.errors[:parent]).to include("must belong to the same taxonomy")
  end
end
