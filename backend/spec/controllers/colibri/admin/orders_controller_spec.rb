require 'spec_helper'
require 'cancan'
require 'colibri/testing_support/bar_ability'

# Ability to test access to specific model instances
class OrderSpecificAbility
  include CanCan::Ability

  def initialize(user)
    can [:admin, :manage], Colibri::Order, :number => 'R987654321'
  end
end

describe Colibri::Admin::OrdersController do

  context "with authorization" do
    stub_authorization!

    before do
      request.env["HTTP_REFERER"] = "http://localhost:3000"

      # ensure no respond_overrides are in effect
      if Colibri::BaseController.colibri_responders[:OrdersController].present?
        Colibri::BaseController.colibri_responders[:OrdersController].clear
      end
    end

    let(:order) { mock_model(Colibri::Order, :complete? => true, :total => 100, :number => 'R123456789') }
    before { Colibri::Order.stub :find_by_number! => order }

    context "#approve" do
      it "approves an order" do
        expect(order).to receive(:approved_by).with(controller.try_colibri_current_user)
        colibri_put :approve, id: order.number
        expect(flash[:success]).to eq Colibri.t(:order_approved)
      end
    end

    context "#cancel" do
      it "cancels an order" do
        expect(order).to receive(:cancel!)
        colibri_put :cancel, id: order.number
        expect(flash[:success]).to eq Colibri.t(:order_canceled)
      end
    end

    context "#resume" do
      it "resumes an order" do
        expect(order).to receive(:resume!)
        colibri_put :resume, id: order.number
        expect(flash[:success]).to eq Colibri.t(:order_resumed)
      end
    end

    context "pagination" do
      it "can page through the orders" do
        colibri_get :index, :page => 2, :per_page => 10
        assigns[:orders].offset_value.should == 10
        assigns[:orders].limit_value.should == 10
      end
    end

    # Test for #3346
    context "#new" do
      it "a new order has the current user assigned as a creator" do
        colibri_get :new
        assigns[:order].created_by.should == controller.try_colibri_current_user
      end
    end

    # Regression test for #3684
    context "#edit" do
      it "does not refresh rates if the order is complete" do
        order.stub :complete? => true
        order.should_not_receive :refresh_shipment_rates
        colibri_get :edit, :id => order.number
      end

      it "does refresh the rates if the order is incomplete" do
        order.stub :complete? => false
        order.should_receive :refresh_shipment_rates
        colibri_get :edit, :id => order.number
      end
    end

    # Test for #3919
    context "search" do
      let(:user) { create(:user) }

      before do
        controller.stub :colibri_current_user => user
        user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')

        create(:completed_order_with_totals)
        expect(Colibri::Order.count).to eq 1
      end

      it "does not display duplicated results" do
        colibri_get :index, q: {
          line_items_variant_id_in: Colibri::Order.first.variants.map(&:id)
        }
        expect(assigns[:orders].map { |o| o.number }.count).to eq 1
      end
    end
  end

  context '#authorize_admin' do
    let(:user) { create(:user) }
    let(:order) { create(:completed_order_with_totals, :number => 'R987654321') }

    before do
      Colibri::Order.stub :find_by_number! => order
      controller.stub :colibri_current_user => user
    end

    it 'should grant access to users with an admin role' do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
      colibri_post :index
      response.should render_template :index
    end

    it 'should grant access to users with an bar role' do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'bar')
      Colibri::Ability.register_ability(BarAbility)
      colibri_post :index
      response.should render_template :index
      Colibri::Ability.remove_ability(BarAbility)
    end

    it 'should deny access to users with an bar role' do
      order.stub(:update_attributes).and_return true
      order.stub(:user).and_return Colibri.user_class.new
      order.stub(:token).and_return nil
      user.colibri_roles.clear
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'bar')
      Colibri::Ability.register_ability(BarAbility)
      colibri_put :update, { :id => 'R123' }
      response.should redirect_to('/unauthorized')
      Colibri::Ability.remove_ability(BarAbility)
    end

    it 'should deny access to users without an admin role' do
      user.stub :has_colibri_role? => false
      colibri_post :index
      response.should redirect_to('/unauthorized')
    end

    it 'should restrict returned order(s) on index when using OrderSpecificAbility' do
      number = order.number

      3.times { create(:completed_order_with_totals) }
      Colibri::Order.complete.count.should eq 4
      Colibri::Ability.register_ability(OrderSpecificAbility)

      user.stub :has_colibri_role? => false
      colibri_get :index
      response.should render_template :index
      assigns['orders'].size.should eq 1
      assigns['orders'].first.number.should eq number
      Colibri::Order.accessible_by(Colibri::Ability.new(user), :index).pluck(:number).should eq  [number]
    end
  end

  context "order number not given" do
    stub_authorization!

    it "raise active record not found" do
      expect {
        colibri_get :edit, id: nil
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
