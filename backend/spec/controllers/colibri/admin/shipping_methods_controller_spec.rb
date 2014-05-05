require 'spec_helper'

describe Colibri::Admin::ShippingMethodsController do
  stub_authorization!

  # Regression test for #1240
  it "should not hard-delete shipping methods" do
    shipping_method = stub_model(Colibri::ShippingMethod)
    Colibri::ShippingMethod.stub :find => shipping_method
    shipping_method.deleted_at.should be_nil
    colibri_delete :destroy, :id => 1
    shipping_method.reload.deleted_at.should_not be_nil
  end
end
