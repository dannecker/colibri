require 'spec_helper'

describe Colibri::OrderPopulator do
  let(:order) { double('Order') }
  subject { Colibri::OrderPopulator.new(order, "USD") }

  context "with stubbed out find_variant" do
    let(:variant) { double('Variant', :name => "T-Shirt", :options_text => "Size: M") }

    before do
     Colibri::Variant.stub(:find).and_return(variant) 
     order.should_receive(:contents).at_least(:once).and_return(Colibri::OrderContents.new(self))
    end

    context "can populate an order" do
      it "can take a list of variants with quantites and add them to the order" do
        order.contents.should_receive(:add).with(variant, 5, subject.currency).and_return double.as_null_object
        subject.populate(2, 5)
      end
    end
  end
end
