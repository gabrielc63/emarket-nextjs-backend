module V1
  class WishlistsController < APIController
    before_action :authenticate_user!
    before_action :set_wishlist, only: %i[show update destroy]

    def index
      @wishlists = current_user.wishlists.includes(wishlist_items: :product).order(created_at: :asc)
    end

    def show
    end

    def create
      @wishlist = current_user.wishlists.new(wishlist_params)

      if @wishlist.save
        render :show, status: :created
      else
        render json: { errors: @wishlist.errors.full_messages }, status: :unprocessable_content
      end
    end

    def update
      if @wishlist.update(wishlist_params)
        render :show, status: :ok
      else
        render json: { errors: @wishlist.errors.full_messages }, status: :unprocessable_content
      end
    end

    def destroy
      @wishlist.destroy!
      head :no_content
    end

    private

    def set_wishlist
      @wishlist = current_user.wishlists.includes(wishlist_items: :product).find(params.expect(:id))
    end

    def wishlist_params
      params.require(:wishlist).permit(:name)
    end
  end
end
