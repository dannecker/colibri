require 'spec_helper'

module Colibri
  module PromotionHandler
    describe Page do
      let(:order) { create(:order_with_line_items, :line_items_count => 1) }

      let(:promotion) { Promotion.create(name: "10% off", :path => '10off') }
      before do
        calculator = Calculator::FlatPercentItemTotal.new(preferred_flat_percent: 10)
        action = Promotion::Actions::CreateItemAdjustments.create(:calculator => calculator)
        promotion.actions << action
      end

      it "activates at the right path" do
        order.line_item_adjustments.count.should == 0
        Colibri::PromotionHandler::Page.new(order, '10off').activate
        order.line_item_adjustments.count.should == 1
      end

      context "when promotion is expired" do
        before do
          promotion.update_columns(
            :starts_at => 1.week.ago,
            :expires_at => 1.day.ago
          )
        end

        it "is not activated" do
          order.line_item_adjustments.count.should == 0
          Colibri::PromotionHandler::Page.new(order, '10off').activate
          order.line_item_adjustments.count.should == 0
        end
      end

      it "does not activate at the wrong path" do
        order.line_item_adjustments.count.should == 0
        Colibri::PromotionHandler::Page.new(order, 'wrongpath').activate
        order.line_item_adjustments.count.should == 0
      end
    end
  end
end

