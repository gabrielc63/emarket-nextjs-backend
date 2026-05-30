module V1
  class ProductsController < APIController
    before_action :set_product, only: %i[show]

    def index
      @products = Product.active
      @products = @products.for_taxon_slug(params[:taxon]) if params[:taxon].present?
      @products = @products.order(created_at: :desc)
    end

    def show
    end

    private

    def set_product
      @product = Product.active.find(params.expect(:id))
    end
  end
end
