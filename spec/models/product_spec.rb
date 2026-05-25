require "rails_helper"

RSpec.describe Product, type: :model do
  it "is valid with valid attributes" do
    product = described_class.new(
      name: "Desk Lamp",
      sku: "HOME-001",
      description: "Adjustable LED desk lamp.",
      price_cents: 4999,
      currency: "usd",
      stock_quantity: 12,
      status: "active"
    )

    expect(product).to be_valid
    expect(product.currency).to eq("USD")
    expect(product.slug).to eq("desk-lamp")
  end

  it "requires non-negative price and stock" do
    product = described_class.new(
      name: "Wireless Headphones",
      slug: "wireless-headphones",
      price_cents: -1,
      stock_quantity: -1,
      status: "active"
    )

    expect(product).not_to be_valid
    expect(product.errors[:price_cents]).to include("must be greater than or equal to 0")
    expect(product.errors[:stock_quantity]).to include("must be greater than or equal to 0")
  end

  it "requires a supported status" do
    product = described_class.new(
      name: "Wireless Headphones",
      slug: "wireless-headphones",
      price_cents: 12999,
      stock_quantity: 20,
      status: "deleted"
    )

    expect(product).not_to be_valid
    expect(product.errors[:status]).to include("is not included in the list")
  end
end
