require 'spec_helper'

module Colibri
  module Stock
    module Splitter
      describe Backordered do
        let(:variant) { build(:variant) }
        let(:line_item) { build(:line_item, variant: variant) }
        let(:packer) { build(:stock_packer) }

        subject { Backordered.new(packer) }

        it 'splits packages by status' do
          package = Package.new(packer.stock_location, packer.order)
          package.add line_item, 4, :on_hand
          package.add line_item, 5, :backordered

          packages = subject.split([package])
          packages.count.should eq 2
          packages.first.quantity.should eq 4
          packages.first.on_hand.count.should eq 1
          packages.first.backordered.count.should eq 0

          packages[1].quantity.should eq 5
        end
      end
    end
  end
end
