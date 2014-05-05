require 'spec_helper'
module Colibri
 describe Colibri::PromotionRulesHelper do
   it "does not include existing rules in options" do
     promotion = Colibri::Promotion.new
     promotion.promotion_rules << Colibri::Promotion::Rules::ItemTotal.new

     options = helper.options_for_promotion_rule_types(promotion)
     options.should_not =~ /ItemTotal/
   end
 end
end
