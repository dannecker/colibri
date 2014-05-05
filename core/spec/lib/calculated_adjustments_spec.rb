require 'spec_helper'

describe Colibri::Core::CalculatedAdjustments do
  it "should add has_one :calculator relationship" do
    assert Colibri::ShippingMethod.reflect_on_all_associations(:has_one).map(&:name).include?(:calculator)
  end
end
