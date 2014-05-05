require 'colibri_core'
require 'colibri/sample'

module ColibriSample
  class Engine < Rails::Engine
    engine_name 'colibri_sample'

    # Needs to be here so we can access it inside the tests
    def self.load_samples
      Colibri::Sample.load_sample("payment_methods")
      Colibri::Sample.load_sample("shipping_categories")
      Colibri::Sample.load_sample("shipping_methods")
      Colibri::Sample.load_sample("tax_categories")
      Colibri::Sample.load_sample("tax_rates")

      Colibri::Sample.load_sample("products")
      Colibri::Sample.load_sample("taxons")
      Colibri::Sample.load_sample("option_values")
      Colibri::Sample.load_sample("product_option_types")
      Colibri::Sample.load_sample("product_properties")
      Colibri::Sample.load_sample("prototypes")
      Colibri::Sample.load_sample("variants")
      Colibri::Sample.load_sample("stock")
      Colibri::Sample.load_sample("assets")

      Colibri::Sample.load_sample("orders")
      Colibri::Sample.load_sample("adjustments")
      Colibri::Sample.load_sample("payments")
    end
  end
end
