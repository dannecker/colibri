require 'spec_helper'

describe Colibri::Promotion::Rules::FirstOrder do
  let(:rule) { Colibri::Promotion::Rules::FirstOrder.new }
  let(:order) { mock_model(Colibri::Order, :user => nil, :email => nil) }
  let(:user) { mock_model(Colibri::LegacyUser) }

  it "should not be eligible without a user or email" do
    rule.should_not be_eligible(order)
  end

  context "first order" do
    context "for a signed user" do
      context "with no completed orders" do
        before(:each) do
          user.stub_chain(:orders, :complete => [])
        end

        specify do
          order.stub(:user => user)
          rule.should be_eligible(order)
        end

        it "should be eligible when user passed in payload data" do
          rule.should be_eligible(order, :user => user)
        end
      end

      context "with completed orders" do
        before(:each) do
          order.stub(:user => user)
        end

        it "should be eligible when checked against first completed order" do
          user.stub_chain(:orders, :complete => [order])
          rule.should be_eligible(order)
        end

        it "should not be eligible with another order" do
          user.stub_chain(:orders, :complete => [mock_model(Colibri::Order)])
          rule.should_not be_eligible(order)
        end
      end
    end

    context "for a guest user" do
      let(:email) { 'user@colibricommerce.com' }
      before { order.stub :email => 'user@colibricommerce.com' }

      context "with no other orders" do
        it { rule.should be_eligible(order) }
      end

      context "with another order" do
        before { rule.stub(:orders_by_email => [mock_model(Colibri::Order)]) }
        it { rule.should_not be_eligible(order) }
      end
    end
  end
end
