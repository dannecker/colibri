module Colibri
  class TaxonsController < Colibri::StoreController
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'colibri/products'

    respond_to :html

    def show
      @taxon = Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(:taxon => @taxon.id))
      @products = @searcher.retrieve_products
      @taxonomies = Colibri::Taxonomy.includes(root: :children)
    end

    private

    def accurate_title
      if @taxon
        @taxon.seo_title
      else
        super
      end
    end

  end
end
