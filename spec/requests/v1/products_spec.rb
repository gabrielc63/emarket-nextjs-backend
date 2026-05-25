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
