require "rails_helper"

RSpec.describe "V1::Wishlists", type: :request do
  def sign_in(user)
    post "/v1/users/sign_in",
      params: { user: { email: user.email, password: "password123" } },
      as: :json

    response.headers.fetch("Authorization")
  end

  it "requires authentication" do
    get "/v1/wishlists", as: :json

    expect(response).to have_http_status(:unauthorized)
  end

  it "lists only the current user's wishlists" do
    user = create(:user, password: "password123")
    other_user = create(:user, password: "password123")
    wishlist = create(:wishlist, user: user, name: "Favorites")
    create(:wishlist, user: other_user, name: "Other Favorites")

    get "/v1/wishlists", headers: { "Authorization" => sign_in(user) }, as: :json

    expect(response).to have_http_status(:ok)

    names = JSON.parse(response.body).map { |item| item.fetch("name") }
    expect(names).to contain_exactly(wishlist.name)
  end

  it "creates, updates, and deletes a wishlist" do
    user = create(:user, password: "password123")
    token = sign_in(user)

    post "/v1/wishlists",
      params: { wishlist: { name: "Favorites" } },
      headers: { "Authorization" => token },
      as: :json

    expect(response).to have_http_status(:created)
    wishlist_id = JSON.parse(response.body).fetch("id")

    patch "/v1/wishlists/#{wishlist_id}",
      params: { wishlist: { name: "Gift Ideas" } },
      headers: { "Authorization" => token },
      as: :json

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).fetch("name")).to eq("Gift Ideas")

    delete "/v1/wishlists/#{wishlist_id}", headers: { "Authorization" => token }, as: :json

    expect(response).to have_http_status(:no_content)
  end

  it "adds and removes products" do
    user = create(:user, password: "password123")
    wishlist = create(:wishlist, user: user)
    product = create(:product)
    token = sign_in(user)

    post "/v1/wishlists/#{wishlist.id}/wishlist_items",
      params: { product_id: product.id },
      headers: { "Authorization" => token },
      as: :json

    expect(response).to have_http_status(:created)

    body = JSON.parse(response.body)
    item = body.fetch("items").first
    expect(item.fetch("product").fetch("id")).to eq(product.id)

    delete "/v1/wishlists/#{wishlist.id}/wishlist_items/#{item.fetch("id")}",
      headers: { "Authorization" => token },
      as: :json

    expect(response).to have_http_status(:no_content)
  end

  it "does not duplicate products when added twice" do
    user = create(:user, password: "password123")
    wishlist = create(:wishlist, user: user)
    product = create(:product)
    token = sign_in(user)

    2.times do
      post "/v1/wishlists/#{wishlist.id}/wishlist_items",
        params: { product_id: product.id },
        headers: { "Authorization" => token },
        as: :json
    end

    expect(response).to have_http_status(:created)
    expect(wishlist.wishlist_items.where(product: product).count).to eq(1)
  end
end
