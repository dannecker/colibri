require 'spec_helper'

describe "colibri/checkout/_summary.html.erb" do
  # Regression spec for #4223
  it "does not use the @order instance variable" do
    order = stub_model(Colibri::Order)
    lambda do
      render :partial => "colibri/checkout/summary", :locals => {:order => order}
    end.should_not raise_error
  end
end
