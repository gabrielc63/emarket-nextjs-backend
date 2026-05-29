module V1
  class TaxonomiesController < APIController
    before_action :set_taxonomy, only: %i[show]

    def index
      @taxonomies = Taxonomy.includes(taxons: :children).order(name: :asc)
    end

    def show
    end

    private

    def set_taxonomy
      @taxonomy = Taxonomy.includes(taxons: :children).find(params.expect(:id))
    end
  end
end
