module Colibri
  class ProductsController < Colibri::StoreController
    before_filter :load_product, :only => :show
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'colibri/taxons'

    respond_to :html

    def index
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Colibri::Taxonomy.includes(root: :children)
    end

    def show
      return unless @product

      @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
      @product_properties = @product.product_properties.includes(:property)
      @taxon = Colibri::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    end

    private
      def accurate_title
        @product ? @product.name : super
      end

      def load_product
        if try_colibri_current_user.try(:has_colibri_role?, "admin")
          @products = Product.with_deleted
        else
          @products = Product.active(current_currency)
        end
        @product = @products.friendly.find(params[:id])
      end
  end
end
