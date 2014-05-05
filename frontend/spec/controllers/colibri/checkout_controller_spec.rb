require 'spec_helper'

describe Colibri::CheckoutController do
  let(:token) { 'some_token' }
  let(:user) { stub_model(Colibri::LegacyUser) }
  let(:order) { FactoryGirl.create(:order_with_totals) }

  let(:address_params) do
    address = FactoryGirl.build(:address)
    address.attributes.except("created_at", "updated_at")
  end

  before do
    controller.stub :try_colibri_current_user => user
    controller.stub :colibri_current_user => user
    controller.stub :current_order => order
  end

  context "#edit" do
    it 'should check if the user is authorized for :edit' do
      controller.should_receive(:authorize!).with(:edit, order, token)
      colibri_get :edit, { :state => 'address' }, { :access_token => token }
    end

    it "should redirect to the cart path unless checkout_allowed?" do
      order.stub :checkout_allowed? => false
      colibri_get :edit, { :state => "delivery" }
      response.should redirect_to(colibri.cart_path)
    end

    it "should redirect to the cart path if current_order is nil" do
      controller.stub(:current_order).and_return(nil)
      colibri_get :edit, { :state => "delivery" }
      response.should redirect_to(colibri.cart_path)
    end

    it "should redirect to cart if order is completed" do
      order.stub(:completed? => true)
      colibri_get :edit, { :state => "address" }
      response.should redirect_to(colibri.cart_path)
    end

    # Regression test for #2280
    it "should redirect to current step trying to access a future step" do
      order.update_column(:state, "address")
      colibri_get :edit, { :state => "delivery" }
      response.should redirect_to colibri.checkout_state_path("address")
    end

    context "when entering the checkout" do
      before do
        # The first step for checkout controller is address
        # Transitioning into this state first is required
        order.update_column(:state, "address")
      end

      it "should associate the order with a user" do
        order.user = nil
        order.should_receive(:associate_user!).with(user)
        colibri_get :edit, {}, :order_id => 1
      end
    end
  end

  context "#update" do
    it 'should check if the user is authorized for :edit' do
      controller.should_receive(:authorize!).with(:edit, order, token)
      colibri_post :update, { :state => 'address' }, { :access_token => token }
    end

    context "save successful" do
      def colibri_post_address
        colibri_post :update, {
          :state => "address",
          :order => {
            :bill_address_attributes => address_params,
            :use_billing => true
          }
        }
      end

      before do
        # Must have *a* shipping method and a payment method so updating from address works
        order.stub :available_shipping_methods => [stub_model(Colibri::ShippingMethod)]
        order.stub :available_payment_methods => [stub_model(Colibri::PaymentMethod)]
        order.stub :ensure_available_shipping_rates => true
        order.line_items << FactoryGirl.create(:line_item)
      end

      context "with the order in the cart state" do
        before do
          order.update_column(:state, "cart")
          order.stub :user => user
        end

        it "should assign order" do
          colibri_post :update, {:state => "address"}
          assigns[:order].should_not be_nil
        end

        it "should advance the state" do
          colibri_post_address
          order.reload.state.should == "delivery"
        end

        it "should redirect the next state" do
          colibri_post_address
          response.should redirect_to colibri.checkout_state_path("delivery")
        end

        context "current_user respond to save address method" do
          it "calls persist order address on user" do
            expect(user).to receive(:persist_order_address)
            colibri_post :update, {
              :state => "address",
              :order => {
                :bill_address_attributes => address_params,
                :use_billing => true
              },
              :save_user_address => "1"
            }
          end
        end

        context "current_user doesnt respond to persist_order_address" do
          it "doesnt raise any error" do
            expect {
              colibri_post :update, {
                :state => "address",
                :order => {
                  :bill_address_attributes => address_params,
                  :use_billing => true
                },
                :save_user_address => "1"
              }
            }.to_not raise_error
          end
        end
      end

      context "when in the confirm state" do
        before do
          order.stub :confirmation_required? => true
          order.update_column(:state, "confirm")
          order.stub :user => user
          # An order requires a payment to reach the complete state
          # This is because payment_required? is true on the order
          create(:payment, :amount => order.total, :order => order)
          order.payments.reload
        end

        # This inadvertently is a regression test for #2694
        it "should redirect to the order view" do
          colibri_post :update, {:state => "confirm"}
          response.should redirect_to colibri.order_path(order)
        end

        it "should populate the flash message" do
          colibri_post :update, {:state => "confirm"}
          flash.notice.should == Colibri.t(:order_processed_successfully)
        end

        it "should remove completed order from the session" do
          colibri_post :update, {:state => "confirm"}, {:order_id => "foofah"}
          session[:order_id].should be_nil
        end
      end
    end

    context "save unsuccessful" do
      before do
        order.stub :user => user
        order.stub :update_attributes => false
      end

      it "should not assign order" do
        colibri_post :update, {:state => "address"}
        assigns[:order].should_not be_nil
      end

      it "should not change the order state" do
        colibri_post :update, { :state => 'address' }
      end

      it "should render the edit template" do
        colibri_post :update, { :state => 'address' }
        response.should render_template :edit
      end
    end

    context "when current_order is nil" do
      before { controller.stub :current_order => nil }

      it "should not change the state if order is completed" do
        order.should_not_receive(:update_attribute)
        colibri_post :update, {:state => "confirm"}
      end

      it "should redirect to the cart_path" do
        colibri_post :update, {:state => "confirm"}
        response.should redirect_to colibri.cart_path
      end
    end

    context "Colibri::Core::GatewayError" do
      before do
        order.stub :user => user
        order.stub(:update_attributes).and_raise(Colibri::Core::GatewayError.new("Invalid something or other."))
        colibri_post :update, {:state => "address"}
      end

      it "should render the edit template and display exception message" do
        response.should render_template :edit
        flash.now[:error].should == Colibri.t(:colibri_gateway_error_flash_for_checkout)
        assigns(:order).errors[:base].should include("Invalid something or other.")
      end
    end

    context "fails to transition from address" do
      let(:order) do
        FactoryGirl.create(:order_with_line_items).tap do |order|
          order.next!
          order.state.should == 'address'
        end
      end

      before do
        controller.stub :current_order => order
        controller.stub :check_authorization => true
      end

      context "when the country is not a shippable country" do
        before do
          order.ship_address.tap do |address|
            # A different country which is not included in the list of shippable countries
            address.country = FactoryGirl.create(:country, :name => "Australia")
            address.state_name = 'Victoria'
            address.save
          end
        end

        it "due to no available shipping rates for any of the shipments" do
          order.shipments.count.should == 1
          order.shipments.first.shipping_rates.delete_all
          colibri_put :update, :order => {}
          flash[:error].should == Colibri.t(:items_cannot_be_shipped)
          response.should redirect_to(colibri.checkout_state_path('address'))
        end
      end

      context "when the order is invalid" do
        before do
          order.stub :update_attributes => true, :next => nil
          order.errors.add :base, 'Base error'
          order.errors.add :adjustments, 'error'
        end

        it "due to the order having errors" do
          colibri_put :update, :order => {}
          flash[:error].should == "Base error\nAdjustments error"
          response.should redirect_to(colibri.checkout_state_path('address'))
        end
      end
    end

    context "fails to transition from payment to complete" do
      let(:order) do
        FactoryGirl.create(:order_with_line_items).tap do |order|
          until order.state == 'payment'
            order.next!
          end
          # So that the confirmation step is skipped and we get straight to the action.
          payment_method = FactoryGirl.create(:simple_credit_card_payment_method)
          payment = FactoryGirl.create(:payment, :payment_method => payment_method)
          order.payments << payment
        end
      end

      before do
        controller.stub :current_order => order
        controller.stub :check_authorization => true
      end

      it "when GatewayError is raised" do
        order.payments.any_instance.stub(:process!).and_raise(Colibri::Core::GatewayError.new(Colibri.t(:payment_processing_failed)))
        colibri_put :update, :order => {}
        flash[:error].should == Colibri.t(:payment_processing_failed)
      end
    end
  end

  context "When last inventory item has been purchased" do
    let(:product) { mock_model(Colibri::Product, :name => "Amazing Object") }
    let(:variant) { mock_model(Colibri::Variant) }
    let(:line_item) { mock_model Colibri::LineItem, :insufficient_stock? => true, :amount => 0 }
    let(:order) { create(:order) }

    before do
      order.stub(:line_items => [line_item], :state => "payment")

      configure_colibri_preferences do |config|
        config.track_inventory_levels = true
      end
    end

    context "and back orders are not allowed" do
      before do
        colibri_post :update, { :state => "payment" }
      end

      it "should redirect to cart" do
        response.should redirect_to colibri.cart_path
      end

      it "should set flash message for no inventory" do
        flash[:error].should == Colibri.t(:inventory_error_flash_for_insufficient_quantity , :names => "'#{product.name}'" )
      end
    end
  end

  context "order doesn't have a delivery step" do
    before do
      order.stub(:checkout_steps => ["cart", "address", "payment"])
      order.stub state: "address"
      controller.stub :check_authorization => true
    end

    it "doesn't set shipping address on the order" do
      expect(order).to receive(:bill_address)
      expect(order).to_not receive(:ship_address)
      colibri_post :update
    end

    it "doesn't remove unshippable items before payment" do
      expect {
        colibri_post :update, { :state => "payment" }
      }.to_not change { order.line_items }
    end
  end

  it "does remove unshippable items before payment" do
    order.stub :payment_required? => true
    controller.stub :check_authorization => true

    expect {
      colibri_post :update, { :state => "payment" }
    }.to change { order.line_items }
  end
end
