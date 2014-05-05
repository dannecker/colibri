require 'spec_helper'

module Colibri
  describe Colibri::Order do
    context "validations" do
      # Regression test for #2214
      it "does not return two error messages when email is blank" do
        order = Colibri::Order.new
        order.stub(:require_email => true)
        order.valid?
        order.errors[:email].should == ["can't be blank"]
      end
    end
  end
end
