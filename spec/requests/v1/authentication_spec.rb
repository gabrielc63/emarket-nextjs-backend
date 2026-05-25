require "rails_helper"

RSpec.describe "V1::Authentication", type: :request do
  it "registers a user and returns a jwt" do
    post "/v1/users",
      params: {
        user: {
          name: "Buyer One",
          email: "buyer@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      },
      as: :json

    expect(response).to have_http_status(:created)
    expect(response.headers["Authorization"]).to start_with("Bearer ")
    expect(response.headers["Set-Cookie"]).to include("emarket_refresh_token")

    body = JSON.parse(response.body)
    expect(body.fetch("email")).to eq("buyer@example.com")
    expect(body.fetch("role")).to eq("customer")
  end

  it "logs in, reads current user, and logs out" do
    user = create(:user, email: "buyer@example.com", password: "password123")

    post "/v1/users/sign_in",
      params: { user: { email: user.email, password: "password123" } },
      as: :json

    expect(response).to have_http_status(:ok)
    token = response.headers.fetch("Authorization")
    expect(response.headers["Set-Cookie"]).to include("emarket_refresh_token")

    get "/v1/current_user", headers: { "Authorization" => token }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).fetch("email")).to eq(user.email)

    delete "/v1/users/sign_out", headers: { "Authorization" => token }

    expect(response).to have_http_status(:no_content)

    get "/v1/current_user", headers: { "Authorization" => token }

    expect(response).to have_http_status(:unauthorized)
  end

  it "refreshes an access token with the HttpOnly refresh cookie" do
    user = create(:user, email: "buyer@example.com", password: "password123")

    post "/v1/users/sign_in",
      params: { user: { email: user.email, password: "password123" } },
      as: :json

    expect(response).to have_http_status(:ok)

    post "/v1/refresh", as: :json

    expect(response).to have_http_status(:ok)
    expect(response.headers["Authorization"]).to start_with("Bearer ")
    expect(response.headers["Set-Cookie"]).to include("emarket_refresh_token")

    refreshed_token = response.headers.fetch("Authorization")

    get "/v1/current_user", headers: { "Authorization" => refreshed_token }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).fetch("email")).to eq(user.email)
  end

  it "updates the current user's profile" do
    user = create(:user, email: "buyer@example.com", password: "password123")

    post "/v1/users/sign_in",
      params: { user: { email: user.email, password: "password123" } },
      as: :json

    token = response.headers.fetch("Authorization")

    patch "/v1/current_user",
      params: { user: { name: "Updated Buyer", email: "updated@example.com" } },
      headers: { "Authorization" => token },
      as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body.fetch("name")).to eq("Updated Buyer")
    expect(body.fetch("email")).to eq("updated@example.com")
  end
end
