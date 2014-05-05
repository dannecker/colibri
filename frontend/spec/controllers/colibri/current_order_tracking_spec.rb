require 'spec_helper'

describe 'current order tracking' do
  let(:user) { create(:user) }

  controller(Colibri::StoreController) do
    def index
      render :nothing => true
    end
  end

  let(:order) { FactoryGirl.create(:order) }

  it 'automatically tracks IP when current_order is called' do
    get :index, {}, { :order_id => order.id }
    controller.current_order.last_ip_address.should == "0.0.0.0"
  end

  it 'automatically tracks who the order was created by' do
    controller.stub(:try_colibri_current_user => user)
    get :index
    controller.current_order(create_order_if_necessary: true).created_by.should == controller.try_colibri_current_user
  end

  context "current order creation" do
    before { controller.stub(:try_colibri_current_user => user) }

    it "doesn't create a new order out of the blue" do
      expect {
        colibri_get :index
      }.not_to change { Colibri::Order.count }
    end
  end
end

describe Colibri::OrdersController do
  let(:user) { create(:user) }

  before { controller.stub(:try_colibri_current_user => user) }

  describe Colibri::OrdersController do
    it "doesn't create a new order out of the blue" do
      expect {
        colibri_get :edit
      }.not_to change { Colibri::Order.count }
    end
  end
end
