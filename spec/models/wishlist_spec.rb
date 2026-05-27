require "rails_helper"

RSpec.describe Wishlist, type: :model do
  it "requires a unique name per user" do
    user = create(:user)
    create(:wishlist, user: user, name: "Favorites")

    duplicate = build(:wishlist, user: user, name: "Favorites")

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include("has already been taken")
  end
end
