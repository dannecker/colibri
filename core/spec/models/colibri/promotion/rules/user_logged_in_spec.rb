require 'spec_helper'

describe Colibri::Promotion::Rules::UserLoggedIn do
  let(:rule) { Colibri::Promotion::Rules::UserLoggedIn.new }

  context "#eligible?(order)" do
    let(:order) { Colibri::Order.new }

    it "should be eligible if order has an associated user" do
      user = double('User')
      order.stub(:user => user)

      rule.should be_eligible(order)
    end

    it "should not be eligible if user is not logged in" do
      order.stub(:user => nil) # better to be explicit here
      rule.should_not be_eligible(order)
    end
  end
end

