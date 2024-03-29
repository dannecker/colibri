# encoding: utf-8

require 'spec_helper'

describe Colibri::Variant do
  let!(:variant) { create(:variant) }

  context "validations" do
    it "should validate price is greater than 0" do
      variant.price = -1
      variant.should be_invalid
    end

    it "should validate price is 0" do
      variant.price = 0
      variant.should be_valid
    end
  end

  context "after create" do
    let!(:product) { create(:product) }

    it "propagate to stock items" do
      Colibri::StockLocation.any_instance.should_receive(:propagate_variant)
      product.variants.create(:name => "Foobar")
    end

    context "stock location has disable propagate all variants" do
      before { Colibri::StockLocation.any_instance.stub(propagate_all_variants?: false) }

      it "propagate to stock items" do
        Colibri::StockLocation.any_instance.should_not_receive(:propagate_variant)
        product.variants.create(:name => "Foobar")
      end
    end
  end

  context "product has other variants" do
    describe "option value accessors" do
      before {
        @multi_variant = FactoryGirl.create :variant, :product => variant.product
        variant.product.reload
      }

      let(:multi_variant) { @multi_variant }

      it "should set option value" do
        multi_variant.option_value('media_type').should be_nil

        multi_variant.set_option_value('media_type', 'DVD')
        multi_variant.option_value('media_type').should == 'DVD'

        multi_variant.set_option_value('media_type', 'CD')
        multi_variant.option_value('media_type').should == 'CD'
      end

      it "should not duplicate associated option values when set multiple times" do
        multi_variant.set_option_value('media_type', 'CD')

        expect {
         multi_variant.set_option_value('media_type', 'DVD')
        }.to_not change(multi_variant.option_values, :count)

        expect {
          multi_variant.set_option_value('coolness_type', 'awesome')
        }.to change(multi_variant.option_values, :count).by(1)
      end
    end

    context "product has other variants" do
      describe "option value accessors" do
        before {
          @multi_variant = create(:variant, :product => variant.product)
          variant.product.reload
        }

        let(:multi_variant) { @multi_variant }

        it "should set option value" do
          multi_variant.option_value('media_type').should be_nil

          multi_variant.set_option_value('media_type', 'DVD')
          multi_variant.option_value('media_type').should == 'DVD'

          multi_variant.set_option_value('media_type', 'CD')
          multi_variant.option_value('media_type').should == 'CD'
        end

        it "should not duplicate associated option values when set multiple times" do
          multi_variant.set_option_value('media_type', 'CD')

          expect {
           multi_variant.set_option_value('media_type', 'DVD')
          }.to_not change(multi_variant.option_values, :count)

          expect {
            multi_variant.set_option_value('coolness_type', 'awesome')
          }.to change(multi_variant.option_values, :count).by(1)
        end
      end
    end
  end

  context "price parsing" do
    before(:each) do
      I18n.locale = I18n.default_locale
      I18n.backend.store_translations(:de, { :number => { :currency => { :format => { :delimiter => '.', :separator => ',' } } } })
    end

    after do
      I18n.locale = I18n.default_locale
    end

    context "price=" do
      context "with decimal point" do
        it "captures the proper amount for a formatted price" do
          variant.price = '1,599.99'
          variant.price.should == 1599.99
        end
      end

      context "with decimal comma" do
        it "captures the proper amount for a formatted price" do
          I18n.locale = :de
          variant.price = '1.599,99'
          variant.price.should == 1599.99
        end
      end

      context "with a numeric price" do
        it "uses the price as is" do
          I18n.locale = :de
          variant.price = 1599.99
          variant.price.should == 1599.99
        end
      end
    end

    context "cost_price=" do
      context "with decimal point" do
        it "captures the proper amount for a formatted price" do
          variant.cost_price = '1,599.99'
          variant.cost_price.should == 1599.99
        end
      end

      context "with decimal comma" do
        it "captures the proper amount for a formatted price" do
          I18n.locale = :de
          variant.cost_price = '1.599,99'
          variant.cost_price.should == 1599.99
        end
      end

      context "with a numeric price" do
        it "uses the price as is" do
          I18n.locale = :de
          variant.cost_price = 1599.99
          variant.cost_price.should == 1599.99
        end
      end
    end
  end

  context "#currency" do
    it "returns the globally configured currency" do
      variant.currency.should == "USD"
    end
  end

  context "#display_amount" do
    it "returns a Colibri::Money" do
      variant.price = 21.22
      variant.display_amount.to_s.should == "$21.22"
    end
  end

  context "#cost_currency" do
    context "when cost currency is nil" do
      before { variant.cost_currency = nil }
      it "populates cost currency with the default value on save" do
        variant.save!
        variant.cost_currency.should == "USD"
      end
    end
  end

  describe '.price_in' do
    before do
      variant.prices << create(:price, :variant => variant, :currency => "EUR", :amount => 33.33)
    end
    subject { variant.price_in(currency).display_amount }

    context "when currency is not specified" do
      let(:currency) { nil }

      it "returns 0" do
        subject.to_s.should == "$0.00"
      end
    end

    context "when currency is EUR" do
      let(:currency) { 'EUR' }

      it "returns the value in the EUR" do
        subject.to_s.should == "€33.33"
      end
    end

    context "when currency is USD" do
      let(:currency) { 'USD' }

      it "returns the value in the USD" do
        subject.to_s.should == "$19.99"
      end
    end
  end

  describe '.amount_in' do
    before do
      variant.prices << create(:price, :variant => variant, :currency => "EUR", :amount => 33.33)
    end

    subject { variant.amount_in(currency) }

    context "when currency is not specified" do
      let(:currency) { nil }

      it "returns nil" do
        subject.should be_nil
      end
    end

    context "when currency is EUR" do
      let(:currency) { 'EUR' }

      it "returns the value in the EUR" do
        subject.should == 33.33
      end
    end

    context "when currency is USD" do
      let(:currency) { 'USD' }

      it "returns the value in the USD" do
        subject.should == 19.99
      end
    end
  end

  # Regression test for #2432
  describe 'options_text' do
    let!(:variant) { create(:variant, option_values: []) }

    before do
      # Order bar than foo
      variant.option_values << create(:option_value, {name: 'Foo', presentation: 'Foo', option_type: create(:option_type, position: 2, name: 'Foo Type', presentation: 'Foo Type')})
      variant.option_values << create(:option_value, {name: 'Bar', presentation: 'Bar', option_type: create(:option_type, position: 1, name: 'Bar Type', presentation: 'Bar Type')})
    end

    it 'should order by bar than foo' do
      variant.options_text.should == 'Bar Type: Bar, Foo Type: Foo'
    end
  end

  # Regression test for #2744
  describe "set_position" do
    it "sets variant position after creation" do
      variant = create(:variant)
      variant.position.should_not be_nil
    end
  end

  describe '#in_stock?' do
    before do
      Colibri::Config.track_inventory_levels = true
    end

    context 'when stock_items are not backorderable' do
      before do
        Colibri::StockItem.any_instance.stub(backorderable: false)
      end

      context 'when stock_items in stock' do
        before do
          variant.stock_items.first.update_column(:count_on_hand, 10)
        end

        it 'returns true if stock_items in stock' do
          variant.in_stock?.should be_true
        end
      end

      context 'when stock_items out of stock' do
        before do
          Colibri::StockItem.any_instance.stub(backorderable: false)
          Colibri::StockItem.any_instance.stub(count_on_hand: 0)
        end

        it 'return false if stock_items out of stock' do
          variant.in_stock?.should be_false
        end
      end
    end

    describe "#can_supply?" do
      it "calls out to quantifier" do
        Colibri::Stock::Quantifier.should_receive(:new).and_return(quantifier = double)
        quantifier.should_receive(:can_supply?).with(10)
        variant.can_supply?(10)
      end
    end

    context 'when stock_items are backorderable' do
      before do
        Colibri::StockItem.any_instance.stub(backorderable: true)
      end

      context 'when stock_items out of stock' do
        before do
          Colibri::StockItem.any_instance.stub(count_on_hand: 0)
        end

        it 'in_stock? returns false' do
          expect(variant.in_stock?).to be_false
        end

        it 'can_supply? return true' do
          expect(variant.can_supply?).to be_true
        end
      end
    end
  end

  describe '#total_on_hand' do
    it 'should be infinite if track_inventory_levels is false' do
      Colibri::Config[:track_inventory_levels] = false
      build(:variant).total_on_hand.should eql(Float::INFINITY)
    end

    it 'should match quantifier total_on_hand' do
      variant = build(:variant)
      expect(variant.total_on_hand).to eq(Colibri::Stock::Quantifier.new(variant).total_on_hand)
    end
  end

  describe '#tax_category' do
    context 'when tax_category is nil' do
      let(:product) { build(:product) }
      let(:variant) { build(:variant, product: product, tax_category_id: nil) }
      it 'returns the parent products tax_category' do
        expect(variant.tax_category).to eq(product.tax_category)
      end
    end

    context 'when tax_category is set' do
      let(:tax_category) { create(:tax_category) }
      let(:variant) { build(:variant, tax_category: tax_category) }
      it 'returns the tax_category set on itself' do
        expect(variant.tax_category).to eq(tax_category)
      end
    end
  end

  describe "touching" do
    it "updates a product" do
      variant.product.update_column(:updated_at, 1.day.ago)
      variant.touch
      variant.product.reload.updated_at.should be_within(3.seconds).of(Time.now)
    end

    it "clears the in_stock cache key" do
      Rails.cache.should_receive(:delete).with(variant.send(:in_stock_cache_key))
      variant.touch
    end
  end

  describe "#should_track_inventory?" do

    it 'should not track inventory when global setting is off' do
      Colibri::Config[:track_inventory_levels] = false

      build(:variant).should_track_inventory?.should eq(false)
    end

    it 'should not track inventory when variant is turned off' do
      Colibri::Config[:track_inventory_levels] = true

      build(:on_demand_variant).should_track_inventory?.should eq(false)
    end

    it 'should track inventory when global and variant are on' do
      Colibri::Config[:track_inventory_levels] = true

      build(:variant).should_track_inventory?.should eq(true)
    end
  end

  describe "deleted_at scope" do
    before { variant.destroy && variant.reload }
    it "should have a price if deleted" do
      variant.price = 10
      expect(variant.price).to eq(10)
    end
  end
end
