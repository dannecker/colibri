# encoding: utf-8

require 'spec_helper'

module Colibri
  describe ProductsHelper do
    include ProductsHelper

    let(:product) { create(:product) }
    let(:currency) { 'USD' }

    before do
      helper.stub(:current_currency) { currency }
    end

    context "#variant_price_diff" do
      let(:product_price) { 10 }
      let(:variant_price) { 10 }

      before do
        @variant = create(:variant, :product => product)
        product.price = 15
        @variant.price = 10
        product.stub(:amount_in) { product_price }
        @variant.stub(:amount_in) { variant_price }
      end

      subject { helper.variant_price(@variant) }

      context "when variant is same as master" do
        it { should be_nil }
      end

      context "when currency is default" do
        context "when variant is more than master" do
          let(:variant_price) { 15 }

          it { should == "(Add: $5.00)" }
          # Regression test for #2737
          it { should be_html_safe }
        end

        context "when variant is less than master" do
          let(:product_price) { 15 }

          it { should == "(Subtract: $5.00)" }
        end
      end

      context "when currency is JPY" do
        let(:variant_price) { 100 }
        let(:product_price) { 100 }
        let(:currency) { 'JPY' }

        context "when variant is more than master" do
          let(:variant_price) { 150 }

          it { should == "(Add: &#x00A5;50)" }
        end

        context "when variant is less than master" do
          let(:product_price) { 150 }

          it { should == "(Subtract: &#x00A5;50)" }
        end
      end
    end

    context "#variant_price_full" do
      before do
        Colibri::Config[:show_variant_full_price] = true
        @variant1 = create(:variant, :product => product)
        @variant2 = create(:variant, :product => product)
      end

      context "when currency is default" do
        it "should return the variant price if the price is different than master" do
          product.price = 10
          @variant1.price = 15
          @variant2.price = 20
          helper.variant_price(@variant1).should == "$15.00"
          helper.variant_price(@variant2).should == "$20.00"
        end
      end

      context "when currency is JPY" do
        let(:currency) { 'JPY' }

        before do
          product.variants.active.each do |variant|
            variant.prices.each do |price|
              price.currency = currency
              price.save!
            end
          end
        end

        it "should return the variant price if the price is different than master" do
          product.price = 100
          @variant1.price = 150
          helper.variant_price(@variant1).should == "&#x00A5;150"
        end
      end

      it "should be nil when all variant prices are equal" do
        product.price = 10
        @variant1.default_price.update_column(:amount, 10)
        @variant2.default_price.update_column(:amount, 10)
        helper.variant_price(@variant1).should be_nil
        helper.variant_price(@variant2).should be_nil
      end
    end


    context "#product_description" do
      # Regression test for #1607
      it "renders a product description without excessive paragraph breaks" do
        product.description = %Q{
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus a ligula leo. Proin eu arcu at ipsum dapibus ullamcorper. Pellentesque egestas orci nec magna condimentum luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut ac ante et mauris bibendum ultricies non sed massa. Fusce facilisis dui eget lacus scelerisque eget aliquam urna ultricies. Duis et rhoncus quam. Praesent tellus nisi, ultrices sed iaculis quis, euismod interdum ipsum.</p>
<ul>
<li>Lorem ipsum dolor sit amet</li>
<li>Lorem ipsum dolor sit amet</li>
</ul>
        }
        description = product_description(product)
        description.strip.should == product.description.strip
      end

      it "renders a product description with automatic paragraph breaks" do
        product.description = %Q{
THIS IS THE BEST PRODUCT EVER!

"IT CHANGED MY LIFE" - Sue, MD}

        description = product_description(product)
        description.strip.should == %Q{<p>\nTHIS IS THE BEST PRODUCT EVER!</p>"IT CHANGED MY LIFE" - Sue, MD}
      end

      it "renders a product description without any formatting based on configuration" do
        initialDescription = %Q{
            <p>hello world</p>

            <p>tihs is completely awesome and it works</p>

            <p>why so many spaces in the code. and why some more formatting afterwards?</p>
        }

        product.description = initialDescription

        Colibri::Config[:show_raw_product_description] = true
        description = product_description(product)
        description.should == initialDescription
      end

    end

    shared_examples_for "line item descriptions" do
      context 'variant has a blank description' do
        let(:description) { nil }
        it { should == Colibri.t(:product_has_no_description) }
      end
      context 'variant has a description' do
        let(:description) { 'test_desc' }
        it { should == description }
      end
      context 'description has nonbreaking spaces' do
        let(:description) { 'test&nbsp;desc' }
        it { should == 'test desc' }
      end
    end

    context "#line_item_description" do
      let(:variant) { create(:variant, :product => product, description: description) }
      subject { line_item_description_text(variant.product.description) }

      it_should_behave_like "line item descriptions"
    end

    context '#line_item_description_text' do
      subject { line_item_description_text description }

      it_should_behave_like "line item descriptions"
    end

    context '#cache_key_for_products' do
      subject { helper.cache_key_for_products }
      before(:each) do
        @products = double('products collection')
        helper.stub(:params) { {:page => 10} }
      end

      context 'when there is a maximum updated date' do
        let(:updated_at) { Date.new(2011, 12, 13) }
        before :each do
          @products.stub(:count) { 5 }
          @products.stub(:maximum).with(:updated_at) { updated_at }
        end

        it { should == 'USD/colibri/products/all-10-20111213-5' }
      end

      context 'when there is no considered maximum updated date' do
        let(:today) { Date.new(2013, 12, 11) }
        before :each do
          @products.stub(:count) { 1234567 }
          @products.stub(:maximum).with(:updated_at) { nil }
          Date.stub(:today) { today }
        end

        it { should == 'USD/colibri/products/all-10-20131211-1234567' }
      end
    end
  end
end
