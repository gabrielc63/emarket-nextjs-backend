require "rails_helper"

RSpec.describe "V1::Products", type: :request do
  describe "GET /v1/products" do
    it "returns active products only" do
      active_product = create(
        :product,
        name: "Wireless Headphones",
        slug: "wireless-headphones"
      )

      draft_product = create(
        :product,
        :draft,
        name: "Draft Laptop",
        slug: "draft-laptop"
      )

      get v1_products_path(format: :json)

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      names = body.map { |product| product.fetch("name") }

      expect(names).to include(active_product.name)
      expect(names).not_to include(draft_product.name)
    end

    it "filters products by taxon slug" do
      taxonomy = create(:taxonomy)
      audio = create(:taxon, taxonomy: taxonomy, name: "Audio", slug: "electronics-audio")
      matching_product = create(:product, name: "Wireless Headphones", slug: "wireless-headphones")
      other_product = create(:product, name: "Running Shoes", slug: "running-shoes")

      create(:product_taxon, product: matching_product, taxon: audio)

      get v1_products_path(format: :json), params: { taxon: "electronics-audio" }

      expect(response).to have_http_status(:ok)

      names = JSON.parse(response.body).map { |product| product.fetch("name") }
      expect(names).to contain_exactly(matching_product.name)
      expect(names).not_to include(other_product.name)
    end

    it "filters products by parent taxon slug and includes descendants" do
      taxonomy = create(:taxonomy)
      electronics = create(:taxon, taxonomy: taxonomy, name: "Electronics", slug: "electronics")
      audio = create(:taxon, taxonomy: taxonomy, parent: electronics, name: "Audio", slug: "electronics-audio")
      matching_product = create(:product, name: "Wireless Headphones", slug: "wireless-headphones")
      other_product = create(:product, name: "Running Shoes", slug: "running-shoes")

      create(:product_taxon, product: matching_product, taxon: audio)

      get v1_products_path(format: :json), params: { taxon: "electronics" }

      expect(response).to have_http_status(:ok)

      names = JSON.parse(response.body).map { |product| product.fetch("name") }
      expect(names).to contain_exactly(matching_product.name)
      expect(names).not_to include(other_product.name)
    end

    it "does not return draft products when filtering by taxon" do
      taxonomy = create(:taxonomy)
      audio = create(:taxon, taxonomy: taxonomy, name: "Audio", slug: "electronics-audio")
      draft_product = create(:product, :draft, name: "Draft Headphones", slug: "draft-headphones")

      create(:product_taxon, product: draft_product, taxon: audio)

      get v1_products_path(format: :json), params: { taxon: "electronics-audio" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end

    it "returns an empty list for an unknown taxon slug" do
      create(:product, name: "Wireless Headphones", slug: "wireless-headphones")

      get v1_products_path(format: :json), params: { taxon: "unknown-category" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end
  end

  describe "GET /v1/products/:id" do
    it "returns an active product" do
      product = create(
        :product,
        name: "Wireless Headphones",
        slug: "wireless-headphones",
        price_cents: 12999
      )

      get v1_product_path(product, format: :json)

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body.fetch("id")).to eq(product.id)
      expect(body.fetch("name")).to eq(product.name)
      expect(body.fetch("price_cents")).to eq(product.price_cents)
    end

    it "does not return draft products" do
      product = create(
        :product,
        :draft,
        name: "Draft Laptop",
        slug: "draft-laptop"
      )

      get v1_product_path(product, format: :json)

      expect(response).to have_http_status(:not_found)
    end
  end
end
