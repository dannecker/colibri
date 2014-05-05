require 'spec_helper'

module Colibri
  class GatewayWithPassword < PaymentMethod
    preference :password, :string, :default => "password"
  end

  describe Admin::PaymentMethodsController do
    stub_authorization!

    let(:payment_method) { GatewayWithPassword.create!(:name => "Bogus", :preferred_password => "haxme") }

    # regression test for #2094
    it "does not clear password on update" do
      payment_method.preferred_password.should == "haxme"
      colibri_put :update, :id => payment_method.id, :payment_method => { :type => payment_method.class.to_s, :preferred_password => "" }
      response.should redirect_to(colibri.edit_admin_payment_method_path(payment_method))

      payment_method.reload
      payment_method.preferred_password.should == "haxme"
    end

    context "tries to save invalid payment" do
      it "doesn't break, responds nicely" do
        expect {
          colibri_post :create, :payment_method => { :name => "", :type => "Colibri::Gateway::Bogus" }
        }.not_to raise_error
      end
    end

    it "can create a payment method of a valid type" do
      expect {
        colibri_post :create, :payment_method => { :name => "Test Method", :type => "Colibri::Gateway::Bogus" }
      }.to change(Colibri::PaymentMethod, :count).by(1)

      response.should be_redirect
      response.should redirect_to colibri.edit_admin_payment_method_path(assigns(:payment_method))
    end

    it "can not create a payment method of an invalid type" do
      expect {
        colibri_post :create, :payment_method => { :name => "Invalid Payment Method", :type => "Colibri::InvalidType" }
      }.to change(Colibri::PaymentMethod, :count).by(0)

      response.should be_redirect
      response.should redirect_to colibri.new_admin_payment_method_path
    end
  end
end
