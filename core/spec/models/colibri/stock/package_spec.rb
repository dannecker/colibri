require 'spec_helper'

module Colibri
  module Stock
    describe Package do
      let(:variant) { build(:variant, weight: 25.0) }
      let(:line_item) { build(:line_item, variant: variant) }
      let(:stock_location) { build(:stock_location) }
      let(:order) { build(:order) }

      subject { Package.new(stock_location, order) }

      it 'calculates the weight of all the contents' do
        subject.add line_item, 4
        subject.weight.should == 100.0
      end

      it 'filters by on_hand and backordered' do
        subject.add line_item, 4, :on_hand
        subject.add line_item, 3, :backordered
        subject.on_hand.count.should eq 1
        subject.backordered.count.should eq 1
      end

      it 'calculates the quantity by state' do
        subject.add line_item, 4, :on_hand
        subject.add line_item, 3, :backordered

        subject.quantity.should eq 7
        subject.quantity(:on_hand).should eq 4
        subject.quantity(:backordered).should eq 3
      end

      it 'returns nil for content item not found' do
        item = subject.find_item(variant, :on_hand)
        item.should be_nil
      end

      it 'finds content item for a variant' do
        subject.add line_item, 4, :on_hand
        item = subject.find_item(variant, :on_hand)
        item.quantity.should eq 4
      end

      it 'get flattened contents' do
        subject.add line_item, 4, :on_hand
        subject.add line_item, 2, :backordered
        flattened = subject.flattened
        flattened.select { |i| i.state == :on_hand }.size.should eq 4
        flattened.select { |i| i.state == :backordered }.size.should eq 2
      end

      it 'set contents from flattened' do
        flattened = [Package::ContentItem.new(line_item, variant, 1, :on_hand),
                    Package::ContentItem.new(line_item, variant, 1, :on_hand),
                    Package::ContentItem.new(line_item, variant, 1, :backordered),
                    Package::ContentItem.new(line_item, variant, 1, :backordered)]

        subject.flattened = flattened
        subject.on_hand.size.should eq 1
        subject.on_hand.first.quantity.should eq 2

        subject.backordered.size.should eq 1
      end

      # Contains regression test for #2804
      it 'builds a list of shipping methods common to all categories' do
        category1 = create(:shipping_category)
        category2 = create(:shipping_category)
        method1   = create(:shipping_method)
        method2   = create(:shipping_method)
        method1.shipping_categories = [category1, category2]
        method2.shipping_categories = [category1]
        variant1 = mock_model(Variant, shipping_category: category1)
        variant2 = mock_model(Variant, shipping_category: category2)
        variant3 = mock_model(Variant, shipping_category: nil)
        contents = [Package::ContentItem.new(line_item, variant1, 1),
                    Package::ContentItem.new(line_item, variant1, 1),
                    Package::ContentItem.new(line_item, variant2, 1),
                    Package::ContentItem.new(line_item, variant3, 1)]

        package = Package.new(stock_location, order, contents)
        package.shipping_methods.should == [method1]
      end

      it 'builds an empty list of shipping methods when no categories' do
        variant  = mock_model(Variant, shipping_category: nil)
        contents = [Package::ContentItem.new(line_item, variant, 1)]
        package  = Package.new(stock_location, order, contents)
        package.shipping_methods.should be_empty
      end

      it "can convert to a shipment" do
        flattened = [Package::ContentItem.new(line_item, variant, 2, :on_hand),
                    Package::ContentItem.new(line_item, variant, 1, :backordered)]
        subject.flattened = flattened

        shipping_method = build(:shipping_method)
        subject.shipping_rates = [ Colibri::ShippingRate.new(shipping_method: shipping_method, cost: 10.00, selected: true) ]

        shipment = subject.to_shipment
        shipment.order.should == subject.order
        shipment.stock_location.should == subject.stock_location
        shipment.inventory_units.size.should == 3

        first_unit = shipment.inventory_units.first
        first_unit.variant.should == variant
        first_unit.state.should == 'on_hand'
        first_unit.order.should == subject.order
        first_unit.should be_pending

        last_unit = shipment.inventory_units.last
        last_unit.variant.should == variant
        last_unit.state.should == 'backordered'
        last_unit.order.should == subject.order

        shipment.shipping_method.should eq shipping_method
      end

      context "line item and variant don't refer same product" do
        let(:other_variant) { build(:variant) }

        before { subject.add(line_item, 4, :on_hand, other_variant) }

        it "cant find the item given wrong variant" do
          expect(subject.find_item(variant, :on_hand)).to be_nil
        end

        it "finds the item when given proper variant and line item" do
          expect(subject.find_item(other_variant, :on_hand)).to eq subject.contents.last
          expect(subject.find_item(other_variant, :on_hand, line_item)).to eq subject.contents.last
        end
      end
    end
  end
end
