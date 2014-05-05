require 'spec_helper'
require 'colibri/core/product_filters'

describe 'product filters' do
  # Regression test for #1709
  context 'finds products filtered by brand' do
    let(:product) { create(:product) }
    before do
      property = Colibri::Property.create!(:name => "brand", :presentation => "brand")
      product.set_property("brand", "Nike")
    end

    it "does not attempt to call value method on Arel::Table" do
      lambda { Colibri::Core::ProductFilters.brand_filter }.should_not raise_error
    end

    it "can find products in the 'Nike' brand" do
      Colibri::Product.brand_any("Nike").should include(product)
    end
    it "sorts products without brand specified" do
      product.set_property("brand", "Nike")
      create(:product).set_property("brand", nil)
      lambda { Colibri::Core::ProductFilters.brand_filter[:labels] }.should_not raise_error
    end
  end
end
