require "rails_helper"

RSpec.describe WishlistItem, type: :model do
  it "prevents duplicate products in the same wishlist" do
    wishlist = create(:wishlist)
    product = create(:product)

    create(:wishlist_item, wishlist: wishlist, product: product)
    duplicate = build(:wishlist_item, wishlist: wishlist, product: product)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:product_id]).to include("has already been taken")
  end
end
