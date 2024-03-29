require 'spec_helper'

Colibri::Order.class_eval do
  attr_accessor :did_transition
end

module Colibri
  describe OrdersController do
    # Regression test for #2004
    context "with a transition callback on first state" do
      let(:order) { Colibri::Order.new }

      before do
        controller.stub :current_order => order
        controller.should_receive(:authorize!).at_least(:once).and_return(true)

        first_state, _ = Colibri::Order.checkout_steps.first
        Colibri::Order.state_machine.after_transition :to => first_state do |order|
          order.did_transition = true
        end
      end

      it "correctly calls the transition callback" do
        order.did_transition.should be_nil
        order.line_items << FactoryGirl.create(:line_item)
        colibri_put :update, { :checkout => "checkout" }, { :order_id => 1}
        order.did_transition.should be_true
      end
    end
  end
end
