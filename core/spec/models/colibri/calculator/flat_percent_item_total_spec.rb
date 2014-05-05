require 'spec_helper'

describe Colibri::Calculator::FlatPercentItemTotal do
  let(:calculator) { Colibri::Calculator::FlatPercentItemTotal.new }
  let(:line_item) { mock_model Colibri::LineItem }

  before { calculator.stub :preferred_flat_percent => 10 }

  context "compute" do
    it "should round result correctly" do
      line_item.stub :amount => 31.08
      calculator.compute(line_item).should == 3.11

      line_item.stub :amount => 31.00
      calculator.compute(line_item).should == 3.10
    end
  end
end
