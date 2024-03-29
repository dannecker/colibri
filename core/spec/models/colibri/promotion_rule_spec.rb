require 'spec_helper'

module Colibri
  describe Colibri::PromotionRule do

    class BadTestRule < Colibri::PromotionRule; end

    class TestRule < Colibri::PromotionRule
      def eligible?
        true
      end
    end

    it "should force developer to implement eligible? method" do
      expect { BadTestRule.new.eligible? }.to raise_error
    end

    it "validates unique rules for a promotion" do
      p1 = TestRule.new
      p1.promotion_id = 1
      p1.save

      p2 = TestRule.new
      p2.promotion_id = 1
      p2.should_not be_valid
    end

  end
end
