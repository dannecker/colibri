module Colibri
  class ShippingMethod < Colibri::Base
    acts_as_paranoid
    include Colibri::Core::CalculatedAdjustments
    DISPLAY = [:both, :front_end, :back_end]

    default_scope -> { where(deleted_at: nil) }

    has_many :shipping_method_categories, :dependent => :destroy
    has_many :shipping_categories, through: :shipping_method_categories
    has_many :shipping_rates, inverse_of: :shipping_method
    has_many :shipments, :through => :shipping_rates

    has_and_belongs_to_many :zones, :join_table => 'colibri_shipping_methods_zones',
                                    :class_name => 'Colibri::Zone',
                                    :foreign_key => 'shipping_method_id'

    belongs_to :tax_category, :class_name => 'Colibri::TaxCategory'

    validates :name, presence: true

    validate :at_least_one_shipping_category

    def include?(address)
      return false unless address
      zones.any? do |zone|
        zone.include?(address)
      end
    end

    def build_tracking_url(tracking)
      return if tracking.blank? || tracking_url.blank?
      tracking_url.gsub(/:tracking/, ERB::Util.url_encode(tracking)) # :url_encode exists in 1.8.7 through 2.1.0
    end

    def self.calculators
      colibri_calculators.send(model_name_without_colibri_namespace).select{ |c| c < Colibri::ShippingCalculator }
    end

    # Some shipping methods are only meant to be set via backend
    def frontend?
      self.display_on != "back_end"
    end

    def tax_category
      Colibri::TaxCategory.unscoped { super }
    end

    private
      def compute_amount(calculable)
        self.calculator.compute(calculable)
      end

      def at_least_one_shipping_category
        if self.shipping_categories.empty?
          self.errors[:base] << "You need to select at least one shipping category"
        end
      end

      def self.on_backend_query
        "#{table_name}.display_on != 'front_end' OR #{table_name}.display_on IS NULL"
      end

      def self.on_frontend_query
        "#{table_name}.display_on != 'back_end' OR #{table_name}.display_on IS NULL"
      end
  end
end
