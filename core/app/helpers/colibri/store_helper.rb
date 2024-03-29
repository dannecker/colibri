# Methods added to this helper will be available to all templates in the frontend.
module Colibri
  module StoreHelper

    # helper to determine if its appropriate to show the store menu
    def store_menu?
      %w{thank_you}.exclude? params[:action]
    end

    def cache_key_for_taxons
      max_updated_at = @taxons.maximum(:updated_at).to_i
      parts = [@taxon.try(:id), max_updated_at].compact.join("-")
      "taxons/#{parts}"
    end
  end
end
