require 'spec_helper'
# This test exists in this file because in the standard admin/products_controller spec
# There is the stub_authorization call. This call is not triggered for this test because
# the load_resource filter in Colibri::Admin::ResourceController is prepended to the filter chain
# this means this call is triggered before the authorize_admin call and in this case
# the load_resource filter halts the request meaning authorize_admin is not called at all.
describe Colibri::Admin::ProductsController do
  stub_authorization!

  # Regression test for GH #538
  it "cannot find a non-existent product" do
    colibri_get :edit, :id => "non-existent-product"
    response.should redirect_to(colibri.admin_products_path)
    flash[:error].should eql("Product is not found")
  end
end


