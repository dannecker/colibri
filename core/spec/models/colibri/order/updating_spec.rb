require 'spec_helper'

describe Colibri::Order do
  let(:order) { stub_model(Colibri::Order) }

  context "#update!" do
    let(:line_items) { [mock_model(Colibri::LineItem, :amount => 5) ]}

    context "when there are update hooks" do
      before { Colibri::Order.register_update_hook :foo }
      after { Colibri::Order.update_hooks.clear }
      it "should call each of the update hooks" do
        order.should_receive :foo
        order.update!
      end
    end
  end
end
