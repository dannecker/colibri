module Colibri
  class Classification < Colibri::Base
    self.table_name = 'colibri_products_taxons'
    acts_as_list
    belongs_to :product, class_name: "Colibri::Product", inverse_of: :classifications
    belongs_to :taxon, class_name: "Colibri::Taxon", inverse_of: :classifications

    # For #3494
    validates_uniqueness_of :taxon_id, :scope => :product_id, :message => :already_linked
  end
end
