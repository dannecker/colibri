require 'spec_helper'
require 'colibri/testing_support/bar_ability'

describe Colibri::Admin::UsersController do
  let(:user) { create(:user) }
  let(:mock_user) { mock_model Colibri.user_class }

  before do
    controller.stub :colibri_current_user => user
    user.colibri_roles.clear
  end

  context "#show" do
    before do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
    end

    it "redirects to edit" do
      colibri_get :show, id: user.id
      expect(response).to redirect_to colibri.edit_admin_user_path(user)
    end
  end

  context '#authorize_admin' do
    before { use_mock_user }

    it 'grant access to users with an admin role' do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
      colibri_post :index
      expect(response).to render_template :index
    end

    it "allows admins to update a user's API key" do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
      mock_user.should_receive(:generate_colibri_api_key!).and_return(true)
      colibri_put :generate_api_key, id: mock_user.id
      expect(response).to redirect_to(colibri.edit_admin_user_path(mock_user))
    end

    it "allows admins to clear a user's API key" do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
      mock_user.should_receive(:clear_colibri_api_key!).and_return(true)
      colibri_put :clear_api_key, id: mock_user.id
      expect(response).to redirect_to(colibri.edit_admin_user_path(mock_user))
    end

    it 'deny access to users with an bar role' do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'bar')
      Colibri::Ability.register_ability(BarAbility)
      colibri_post :index
      expect(response).to redirect_to '/unauthorized'
    end

    it 'deny access to users with an bar role' do
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'bar')
      Colibri::Ability.register_ability(BarAbility)
      colibri_post :update, { id: '9' }
      expect(response).to redirect_to '/unauthorized'
    end

    it 'deny access to users without an admin role' do
      user.stub :has_colibri_role? => false
      colibri_post :index
      expect(response).to redirect_to '/unauthorized'
    end
  end

  describe "#create" do
    before do
      use_mock_user
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
    end

    it "can create a shipping_address" do
      Colibri.user_class.should_receive(:new).with(hash_including(
        "ship_address_attributes" => { "city" => "New York" }
      ))
      colibri_post :create, { :user => { :ship_address_attributes => { :city => "New York" } } }
    end

    it "can create a billing_address" do
      Colibri.user_class.should_receive(:new).with(hash_including(
        "bill_address_attributes" => { "city" => "New York" }
      ))
      colibri_post :create, { :user => { :bill_address_attributes => { :city => "New York" } } }
    end
  end

  describe "#update" do
    before do
      use_mock_user
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
    end

    it "allows shipping address attributes through" do
      mock_user.should_receive(:update_attributes).with(hash_including(
        "ship_address_attributes" => { "city" => "New York" }
      ))
      colibri_put :update, { :id => mock_user.id, :user => { :ship_address_attributes => { :city => "New York" } } }
    end

    it "allows billing address attributes through" do
      mock_user.should_receive(:update_attributes).with(hash_including(
        "bill_address_attributes" => { "city" => "New York" }
      ))
      colibri_put :update, { :id => mock_user.id, :user => { :bill_address_attributes => { :city => "New York" } } }
    end
  end

  describe "#orders" do
    let(:order) { create(:order) }
    before do
      user.orders << order
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
    end

    it "assigns a list of the users orders" do
      colibri_get :orders, { :id => user.id }
      expect(assigns[:orders].count).to eq 1
      expect(assigns[:orders].first).to eq order
    end

    it "assigns a ransack search for Colibri::Order" do
      colibri_get :orders, { :id => user.id }
      expect(assigns[:search]).to be_a Ransack::Search
      expect(assigns[:search].klass).to eq Colibri::Order
    end
  end

  describe "#items" do
    let(:order) { create(:order) }
    before do
      user.orders << order
      user.colibri_roles << Colibri::Role.find_or_create_by(name: 'admin')
    end

    it "assigns a list of the users orders" do
      colibri_get :items, { :id => user.id }
      expect(assigns[:orders].count).to eq 1
      expect(assigns[:orders].first).to eq order
    end

    it "assigns a ransack search for Colibri::Order" do
      colibri_get :items, { :id => user.id }
      expect(assigns[:search]).to be_a Ransack::Search
      expect(assigns[:search].klass).to eq Colibri::Order
    end
  end
end

def use_mock_user
  mock_user.stub(:save).and_return(true)
  Colibri.user_class.stub(:find).with(mock_user.id.to_s).and_return(mock_user)
  Colibri.user_class.stub(:new).and_return(mock_user)
end
