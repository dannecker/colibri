require 'spec_helper'

describe Colibri::Api::BaseController do
  render_views
  controller(Colibri::Api::BaseController) do
    def index
      render :text => { "products" => [] }.to_json
    end
  end

  context "signed in as a user using an authentication extension" do
    before do
      controller.stub :try_colibri_current_user => double(:email => "colibri@example.com")
      Colibri::Api::Config[:requires_authentication] = true
    end

    it "can make a request" do
      api_get :index
      json_response.should == { "products" => [] }
      response.status.should == 200
    end
  end

  context "when validating based on an order token" do
    let!(:order) { create :order }

    context "with a correct order token" do
      it "succeeds" do
        api_get :index, order_token: order.token, order_id: order.number
        response.status.should == 200
      end

      it "succeeds with an order_number parameter" do
        api_get :index, order_token: order.token, order_number: order.number
        response.status.should == 200
      end
    end

    context "with an incorrect order token" do
      it "returns unauthorized" do
        api_get :index, order_token: "NOT_A_TOKEN", order_id: order.number
        response.status.should == 401
      end
    end
  end

  context "cannot make a request to the API" do
    it "without an API key" do
      api_get :index
      json_response.should == { "error" => "You must specify an API key." }
      response.status.should == 401
    end

    it "with an invalid API key" do
      request.headers["X-Colibri-Token"] = "fake_key"
      get :index, {}
      json_response.should == { "error" => "Invalid API key (fake_key) specified." }
      response.status.should == 401
    end

    it "using an invalid token param" do
      get :index, :token => "fake_key"
      json_response.should == { "error" => "Invalid API key (fake_key) specified." }
    end
  end

  it 'handles exceptions' do
    subject.should_receive(:authenticate_user).and_return(true)
    subject.should_receive(:index).and_raise(Exception.new("no joy"))
    get :index, :token => "fake_key"
    json_response.should == { "exception" => "no joy" }
  end

  it "maps symantec keys to nested_attributes keys" do
    klass = double(:nested_attributes_options => { :line_items => {},
                                                  :bill_address => {} })
    attributes = { 'line_items' => { :id => 1 },
                   'bill_address' => { :id => 2 },
                   'name' => 'test order' }

    mapped = subject.map_nested_attributes_keys(klass, attributes)
    mapped.has_key?('line_items_attributes').should be_true
    mapped.has_key?('name').should be_true
  end
end
