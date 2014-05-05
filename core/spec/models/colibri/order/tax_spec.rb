require 'spec_helper'

module Colibri
  describe Colibri::Order do
    let(:order) { stub_model(Colibri::Order) }

    context "#tax_zone" do
      let(:bill_address) { create :address }
      let(:ship_address) { create :address }
      let(:order) { Colibri::Order.create(:ship_address => ship_address, :bill_address => bill_address) }
      let(:zone) { create :zone }

      context "when no zones exist" do
        before { Colibri::Zone.destroy_all }

        it "should return nil" do
          order.tax_zone.should be_nil
        end
      end

      context "when :tax_using_ship_address => true" do
        before { Colibri::Config.set(:tax_using_ship_address => true) }

        it "should calculate using ship_address" do
          Colibri::Zone.should_receive(:match).at_least(:once).with(ship_address)
          Colibri::Zone.should_not_receive(:match).with(bill_address)
          order.tax_zone
        end
      end

      context "when :tax_using_ship_address => false" do
        before { Colibri::Config.set(:tax_using_ship_address => false) }

        it "should calculate using bill_address" do
          Colibri::Zone.should_receive(:match).at_least(:once).with(bill_address)
          Colibri::Zone.should_not_receive(:match).with(ship_address)
          order.tax_zone
        end
      end

      context "when there is a default tax zone" do
        before do
          @default_zone = create(:zone, :name => "foo_zone")
          Colibri::Zone.stub :default_tax => @default_zone
        end

        context "when there is a matching zone" do
          before { Colibri::Zone.stub(:match => zone) }

          it "should return the matching zone" do
            order.tax_zone.should == zone
          end
        end

        context "when there is no matching zone" do
          before { Colibri::Zone.stub(:match => nil) }

          it "should return the default tax zone" do
            order.tax_zone.should == @default_zone
          end
        end
      end

      context "when no default tax zone" do
        before { Colibri::Zone.stub :default_tax => nil }

        context "when there is a matching zone" do
          before { Colibri::Zone.stub(:match => zone) }

          it "should return the matching zone" do
            order.tax_zone.should == zone
          end
        end

        context "when there is no matching zone" do
          before { Colibri::Zone.stub(:match => nil) }

          it "should return nil" do
            order.tax_zone.should be_nil
          end
        end
      end
    end

  end
end
