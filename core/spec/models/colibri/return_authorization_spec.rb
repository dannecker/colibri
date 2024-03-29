require 'spec_helper'

describe Colibri::ReturnAuthorization do
  let(:stock_location) { Colibri::StockLocation.create(:name => "test") }
  let(:order) { FactoryGirl.create(:shipped_order) }

  let(:variant) { order.variants.first }
  let(:return_authorization) { Colibri::ReturnAuthorization.new(:order => order, :stock_location_id => stock_location.id) }

  context "save" do
    let(:order) { Colibri::Order.create }

    it "should be invalid when order has no inventory units" do
      return_authorization.save
      return_authorization.errors[:order].should == ["has no shipped units"]
    end
  end

  describe ".before_create" do
    describe "#generate_number" do
      context "number is assigned" do
        let(:return_authorization) { Colibri::ReturnAuthorization.new(number: '123') }

        it "should return the assigned number" do
          return_authorization.save
          return_authorization.number.should == '123'
        end
      end

      context "number is not assigned" do
        let(:return_authorization) { Colibri::ReturnAuthorization.new(number: nil) }

        before { return_authorization.stub valid?: true }

        it "should assign number with random RMA number" do
          return_authorization.save
          return_authorization.number.should =~ /RMA\d{9}/
        end
      end
    end
  end

  context "add_variant" do
    context "on empty rma" do
      it "should associate inventory units as shipped" do
        return_authorization.add_variant(variant.id, 1)
        expect(return_authorization.inventory_units.where(state: 'shipped').size).to eq 1
      end

      it "should update order state" do
        order.should_receive(:authorize_return!)
        return_authorization.add_variant(variant.id, 1)
      end
    end

    context "on rma that already has inventory_units" do
      before do
        return_authorization.add_variant(variant.id, 1)
      end

      it "should not associate more inventory units than there are on the order" do
        return_authorization.add_variant(variant.id, 1)
        expect(return_authorization.inventory_units.size).to eq 1
      end

      it "should not update order state" do
        expect{return_authorization.add_variant(variant.id, 1)}.to_not change{order.state}
      end
    end
  end

  context "can_receive?" do
    it "should allow_receive when inventory units assigned" do
      return_authorization.stub(:inventory_units => [1,2,3])
      return_authorization.can_receive?.should be_true
    end

    it "should not allow_receive with no inventory units" do
      return_authorization.stub(:inventory_units => [])
      return_authorization.can_receive?.should be_false
    end
  end

  context "receive!" do
    let(:inventory_unit) { order.shipments.first.inventory_units.first }

    context "to the initial stock location" do
      before do
        return_authorization.stub(:inventory_units => [inventory_unit], :amount => -20)
        return_authorization.stub(:stock_location_id => inventory_unit.shipment.stock_location.id)
        Colibri::Adjustment.stub(:create)
        order.stub(:update!)
      end

      it "should mark all inventory units are returned" do
        inventory_unit.should_receive(:return!)
        return_authorization.receive!
      end

      it "should add credit for specified amount" do
        return_authorization.amount = 20
        mock_adjustment = double
        mock_adjustment.should_receive(:source=).with(return_authorization)
        mock_adjustment.should_receive(:adjustable=).with(order)
        mock_adjustment.should_receive(:save)
        Colibri::Adjustment.should_receive(:new).with(:amount => -20, :label => Colibri.t(:rma_credit)).and_return(mock_adjustment)
        return_authorization.receive!
      end

      it "should update order state" do
        order.should_receive :update!
        return_authorization.receive!
      end

      it "should update the stock item counts in the stock location" do
        count_on_hand = inventory_unit.find_stock_item.count_on_hand
        return_authorization.receive!
        inventory_unit.find_stock_item.count_on_hand.should == count_on_hand + 1
      end
    end

    context "to a different stock location" do
      let(:new_stock_location) { FactoryGirl.create(:stock_location, :name => "other") }
      before do
        return_authorization.stub(:stock_location_id => new_stock_location.id)
        return_authorization.stub(:inventory_units => [inventory_unit], :amount => -20)
      end

      it "should update the stock item counts in new stock location" do
        count_on_hand = Colibri::StockItem.where(variant_id: inventory_unit.variant_id, stock_location_id: new_stock_location.id).first.count_on_hand
        return_authorization.receive!
        Colibri::StockItem.where(variant_id: inventory_unit.variant_id, stock_location_id: new_stock_location.id).first.count_on_hand.should == count_on_hand + 1
      end

      it "should not update the stock item counts in the original stock location" do
        count_on_hand = inventory_unit.find_stock_item.count_on_hand
        return_authorization.receive!
        inventory_unit.find_stock_item.count_on_hand.should == count_on_hand
      end
    end
  end

  context "force_positive_amount" do
    it "should ensure the amount is always positive" do
      return_authorization.amount = -10
      return_authorization.send :force_positive_amount
      return_authorization.amount.should == 10
    end
  end

  context "after_save" do
    it "should run correct callbacks" do
      return_authorization.should_receive(:force_positive_amount)
      return_authorization.run_callbacks(:save)
    end
  end

  context "currency" do
    before { order.stub(:currency) { "ABC" } }
    it "returns the order currency" do
      return_authorization.currency.should == "ABC"
    end
  end

  context "display_amount" do
    it "returns a Colibri::Money" do
      return_authorization.amount = 21.22
      return_authorization.display_amount.should == Colibri::Money.new(21.22)
    end
  end

  context "returnable_inventory" do
    pending "should return inventory from shipped shipments" do
      return_authorization.returnable_inventory.should == [inventory_unit]
    end

    pending "should not return inventory from unshipped shipments" do
      return_authorization.returnable_inventory.should == []
    end
  end
end
