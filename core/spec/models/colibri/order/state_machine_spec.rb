require 'spec_helper'

describe Colibri::Order do
  let(:order) { Colibri::Order.new }
  before do
    # Ensure state machine has been re-defined correctly
    Colibri::Order.define_state_machine!
    # We don't care about this validation here
    order.stub(:require_email)
  end

  context "#next!" do
    context "when current state is confirm" do
      before do
        order.state = "confirm"
        order.run_callbacks(:create)
        order.stub :payment_required? => true
        order.stub :process_payments! => true
        order.stub :has_available_shipment
      end

      context "when payment processing succeeds" do
        before { order.stub :process_payments! => true }

        it "should finalize order when transitioning to complete state" do
          order.should_receive(:finalize!)
          order.next!
        end

        context "when credit card processing fails" do
          before { order.stub :process_payments! => false }

          it "should not complete the order" do
             order.next
             order.state.should == "confirm"
           end
        end

      end

      context "when payment processing fails" do
        before { order.stub :process_payments! => false }

        it "cannot transition to complete" do
         order.next
         order.state.should == "confirm"
        end
      end
    end

    context "when current state is delivery" do
      before do
        order.stub :payment_required? => true
        order.stub :apply_free_shipping_promotions
        order.state = "delivery"
      end

      it "adjusts tax rates when transitioning to delivery" do
        # Once for the line items
        Colibri::TaxRate.should_receive(:adjust).once
        order.stub :set_shipments_cost
        order.next!
      end

      it "adjusts tax rates twice if there are any shipments" do
        # Once for the line items, once for the shipments
        order.shipments.build
        Colibri::TaxRate.should_receive(:adjust).twice
        order.stub :set_shipments_cost
        order.next!
      end
    end
  end

  context "#can_cancel?" do

    %w(pending backorder ready).each do |shipment_state|
      it "should be true if shipment_state is #{shipment_state}" do
        order.stub :completed? => true
        order.shipment_state = shipment_state
        order.can_cancel?.should be_true
      end
    end

    (Colibri::Shipment.state_machine.states.keys - %w(pending backorder ready)).each do |shipment_state|
      it "should be false if shipment_state is #{shipment_state}" do
        order.stub :completed? => true
        order.shipment_state = shipment_state
        order.can_cancel?.should be_false
      end
    end

  end

  context "#cancel" do
    let!(:variant) { stub_model(Colibri::Variant) }
    let!(:inventory_units) { [stub_model(Colibri::InventoryUnit, :variant => variant),
                              stub_model(Colibri::InventoryUnit, :variant => variant) ]}
    let!(:shipment) do
      shipment = stub_model(Colibri::Shipment)
      shipment.stub :inventory_units => inventory_units
      order.stub :shipments => [shipment]
      shipment
    end

    before do
      order.stub :line_items => [stub_model(Colibri::LineItem, :variant => variant, :quantity => 2)]
      order.line_items.stub :find_by_variant_id => order.line_items.first

      order.stub :completed? => true
      order.stub :allow_cancel? => true
    end

    it "should send a cancel email" do
      # Stub methods that cause side-effects in this test
      shipment.stub(:cancel!)
      order.stub :has_available_shipment
      order.stub :restock_items!
      mail_message = double "Mail::Message"
      order_id = nil
      Colibri::OrderMailer.should_receive(:cancel_email) { |*args|
        order_id = args[0]
        mail_message
      }
      mail_message.should_receive :deliver
      order.cancel!
      order_id.should == order.id
    end

    context "restocking inventory" do
      before do
        shipment.stub(:ensure_correct_adjustment)
        shipment.stub(:update_order)
        Colibri::OrderMailer.stub(:cancel_email).and_return(mail_message = double)
        mail_message.stub :deliver

        order.stub :has_available_shipment
      end
    end

    context "resets payment state" do
      before do
        # TODO: This is ugly :(
        # Stubs methods that cause unwanted side effects in this test
        Colibri::OrderMailer.stub(:cancel_email).and_return(mail_message = double)
        mail_message.stub :deliver
        order.stub :has_available_shipment
        order.stub :restock_items!
        shipment.stub(:cancel!)
      end

      context "without shipped items" do
        it "should set payment state to 'credit owed'" do
          # Regression test for #3711
          order.should_receive(:update_column).with(:payment_state, 'credit_owed')
          order.cancel!
        end
      end

      context "with shipped items" do
        before do
          order.stub :shipment_state => 'partial'
        end

        it "should not alter the payment state" do
          order.cancel!
          order.payment_state.should be_nil
        end
      end

      context "with payments" do
        let(:payment) { create(:payment) }

        it "should automatically refund all payments" do
          order.stub_chain(:payments, :completed).and_return([payment])
          payment.should_receive(:credit!)
          order.cancel!
        end
      end
    end
  end


  # Another regression test for #729
  context "#resume" do
    before do
      order.stub :email => "user@colibricommerce.com"
      order.stub :state => "canceled"
      order.stub :allow_resume? => true

      # Stubs method that cause unwanted side effects in this test
      order.stub :has_available_shipment
    end
  end
end
