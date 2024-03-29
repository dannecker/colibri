require 'spec_helper'

describe "Switching currencies in backend" do
  before do
    create(:base_product, :name => "RoR Mug")
  end

  # Regression test for #2340
  it "does not cause current_order to become nil", inaccessible: true do
    visit colibri.root_path
    click_link "RoR Mug"
    click_button "Add To Cart"
    # Now that we have an order...
    Colibri::Config[:currency] = "AUD"
    lambda { visit colibri.root_path }.should_not raise_error
  end

end
