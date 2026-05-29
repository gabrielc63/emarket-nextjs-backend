require "rails_helper"

RSpec.describe "V1::Taxonomies", type: :request do
  it "lists taxonomies with nested taxons" do
    taxonomy = create(:taxonomy, name: "Categories", slug: "categories")
    parent = create(:taxon, taxonomy: taxonomy, name: "Electronics", slug: "electronics")
    create(:taxon, taxonomy: taxonomy, parent: parent, name: "Headphones", slug: "electronics-headphones")

    get "/v1/taxonomies", as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body.first.fetch("name")).to eq("Categories")
    expect(body.first.fetch("taxons").first.fetch("name")).to eq("Electronics")
    expect(body.first.fetch("taxons").first.fetch("children").first.fetch("name")).to eq("Headphones")
  end

  it "shows a taxonomy" do
    taxonomy = create(:taxonomy, name: "Categories", slug: "categories")

    get "/v1/taxonomies/#{taxonomy.id}", as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).fetch("slug")).to eq("categories")
  end
end
