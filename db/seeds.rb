# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

products = [
  {
    name: "Wireless Headphones",
    slug: "wireless-headphones",
    sku: "AUDIO-001",
    description: "Noise-canceling wireless headphones with long battery life.",
    price_cents: 12_999,
    currency: "USD",
    stock_quantity: 20,
    status: "active"
  },
  {
    name: "Smart Home Hub",
    slug: "smart-home-hub",
    sku: "HOME-001",
    description: "Control lights, routines, and compatible devices from one hub.",
    price_cents: 8_999,
    currency: "USD",
    stock_quantity: 15,
    status: "active"
  },
  {
    name: "Running Shoes",
    slug: "running-shoes",
    sku: "SPORT-001",
    description: "Lightweight running shoes built for daily training.",
    price_cents: 7_499,
    currency: "USD",
    stock_quantity: 30,
    status: "active"
  },
  {
    name: "Ergonomic Office Chair",
    slug: "ergonomic-office-chair",
    sku: "OFFICE-001",
    description: "Adjustable office chair with lumbar support.",
    price_cents: 19_999,
    currency: "USD",
    stock_quantity: 10,
    status: "active"
  },
  {
    name: "Stainless Steel Cookware Set",
    slug: "stainless-steel-cookware-set",
    sku: "KITCHEN-001",
    description: "Durable cookware set for everyday cooking.",
    price_cents: 14_999,
    currency: "USD",
    stock_quantity: 8,
    status: "active"
  },
  {
    name: "Draft Marketplace Product",
    slug: "draft-marketplace-product",
    sku: "DRAFT-001",
    description: "Example draft product hidden from the public products API.",
    price_cents: 9_999,
    currency: "USD",
    stock_quantity: 5,
    status: "draft"
  }
]

products.each do |attributes|
  product = Product.find_or_initialize_by(slug: attributes.fetch(:slug))
  product.update!(attributes)
end

puts "Seeded #{products.length} products."

categories = Taxonomy.find_or_initialize_by(slug: "categories")
categories.update!(name: "Categories")

category_taxons = [
  { name: "Electronics", slug: "electronics", position: 1 },
  { name: "Audio", slug: "electronics-audio", parent_slug: "electronics", position: 1 },
  { name: "Smart Home", slug: "electronics-smart-home", parent_slug: "electronics", position: 2 },
  { name: "Fashion", slug: "fashion", position: 2 },
  { name: "Footwear", slug: "fashion-footwear", parent_slug: "fashion", position: 1 },
  { name: "Home", slug: "home", position: 3 },
  { name: "Kitchen", slug: "home-kitchen", parent_slug: "home", position: 1 },
  { name: "Office", slug: "home-office", parent_slug: "home", position: 2 }
]

category_taxons.each do |attributes|
  taxon = Taxon.find_or_initialize_by(slug: attributes.fetch(:slug))
  parent = attributes[:parent_slug] ? Taxon.find_by!(slug: attributes.fetch(:parent_slug)) : nil
  taxon.update!(
    taxonomy: categories,
    parent: parent,
    name: attributes.fetch(:name),
    position: attributes.fetch(:position)
  )
end

product_taxons = {
  "wireless-headphones" => "electronics-audio",
  "smart-home-hub" => "electronics-smart-home",
  "running-shoes" => "fashion-footwear",
  "ergonomic-office-chair" => "home-office",
  "stainless-steel-cookware-set" => "home-kitchen"
}

product_taxons.each do |product_slug, taxon_slug|
  product = Product.find_by!(slug: product_slug)
  taxon = Taxon.find_by!(slug: taxon_slug)
  ProductTaxon.find_or_create_by!(product: product, taxon: taxon)
end

puts "Seeded #{category_taxons.length} taxons."
