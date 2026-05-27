module V1
  class WishlistItemsController < APIController
    before_action :authenticate_user!
    before_action :set_wishlist

    def create
      product = Product.active.find(params.expect(:product_id))
      wishlist_item = @wishlist.wishlist_items.find_or_initialize_by(product: product)

      if wishlist_item.persisted? || wishlist_item.save
        @wishlist.reload
        render "v1/wishlists/show", status: :created
      else
        render json: { errors: wishlist_item.errors.full_messages }, status: :unprocessable_content
      end
    end

    def destroy
      wishlist_item = @wishlist.wishlist_items.find(params.expect(:id))
      wishlist_item.destroy!
      head :no_content
    end

    private

    def set_wishlist
      @wishlist = current_user.wishlists.includes(wishlist_items: :product).find(params.expect(:wishlist_id))
    end
  end
end
