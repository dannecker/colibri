require 'spec_helper'

describe Colibri::Admin::ReturnAuthorizationsController do
  stub_authorization!

  # Regression test for #1370 #3
  let!(:order) { create(:order) }
  it "can create a return authorization" do
    colibri_post :create, :order_id => order.to_param, :return_authorization => { :amount => 0.0, :reason => "" }
    response.should be_success
  end
end
