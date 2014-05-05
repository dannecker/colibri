module Colibri
  class HomeController < Colibri::StoreController
    helper 'colibri/products'
    respond_to :html

    def index
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Colibri::Taxonomy.includes(root: :children)
    end
  end
end
