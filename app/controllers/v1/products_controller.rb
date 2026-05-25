module V1
  class ProductsController < APIController
    before_action :set_product, only: %i[show]

    def index
      @products = Product.active.order(created_at: :desc)
    end

    def show
    end

    private

    def set_product
      @product = Product.active.find(params.expect(:id))
    end
  end
end
