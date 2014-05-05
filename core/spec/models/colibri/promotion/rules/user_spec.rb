require 'spec_helper'

describe Colibri::Promotion::Rules::User do
  let(:rule) { Colibri::Promotion::Rules::User.new }

  context "#eligible?(order)" do
    let(:order) { Colibri::Order.new }

    it "should not be eligible if users are not provided" do
      rule.should_not be_eligible(order)
    end

    it "should be eligible if users include user placing the order" do
      user = mock_model(Colibri::LegacyUser)
      users = [user, mock_model(Colibri::LegacyUser)]
      rule.stub(:users => users)
      order.stub(:user => user)

      rule.should be_eligible(order)
    end

    it "should not be eligible if user placing the order is not listed" do
      order.stub(:user => mock_model(Colibri::LegacyUser))
      users = [mock_model(Colibri::LegacyUser), mock_model(Colibri::LegacyUser)]
      rule.stub(:users => users)

      rule.should_not be_eligible(order)
    end

    # Regression test for #3885
    it "can assign to user_ids" do
      user1 = Colibri::LegacyUser.create!(:email => "test1@example.com")
      user2 = Colibri::LegacyUser.create!(:email => "test2@example.com")
      lambda { rule.user_ids = "#{user1.id}, #{user2.id}" }.should_not raise_error
    end
  end
end
