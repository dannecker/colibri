require 'spec_helper'

describe "Promotion Adjustments" do
  stub_authorization!

  context "coupon promotions", :js => true do
    before(:each) do
      visit colibri.admin_path
      click_link "Promotions"
      click_link "New Promotion"
    end

    it "should allow an admin to create a flat rate discount coupon promo" do
      fill_in "Name", :with => "Promotion"
      fill_in "Code", :with => "order"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Item total", :from => "Add rule of type"
      within('#rule_fields') { click_button "Add" }

      eventually_fill_in "promotion_promotion_rules_attributes_#{Colibri::Promotion.count}_preferred_amount", :with => 30
      within('#rule_fields') { click_button "Update" }

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Flat Rate", :from => "Calculator"
      within('#actions_container') { click_button "Update" }

      within('.calculator-fields') { fill_in "Amount", :with => 5 }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.code.should == "order"

      first_rule = promotion.rules.first
      first_rule.class.should == Colibri::Promotion::Rules::ItemTotal
      first_rule.preferred_amount.should == 30

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateAdjustment
      first_action_calculator = first_action.calculator
      first_action_calculator.class.should == Colibri::Calculator::FlatRate
      first_action_calculator.preferred_amount.should == 5
    end

    it "should allow an admin to create a single user coupon promo with flat rate discount" do
      fill_in "Name", :with => "Promotion"
      fill_in "Usage Limit", :with => "1"
      fill_in "Code", :with => "single_use"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Flat Rate", :from => "Calculator"
      within('#actions_container') { click_button "Update" }
      within('#action_fields') { fill_in "Amount", :with => "5" }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.usage_limit.should == 1
      promotion.code.should == "single_use"

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateAdjustment
      first_action_calculator = first_action.calculator
      first_action_calculator.class.should == Colibri::Calculator::FlatRate
      first_action_calculator.preferred_amount.should == 5
    end

    it "should allow an admin to create an automatic promo with flat percent discount" do
      fill_in "Name", :with => "Promotion"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Item total", :from => "Add rule of type"
      within('#rule_fields') { click_button "Add" }

      eventually_fill_in "promotion_promotion_rules_attributes_1_preferred_amount", :with => 30
      within('#rule_fields') { click_button "Update" }

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Flat Percent", :from => "Calculator"
      within('#actions_container') { click_button "Update" }
      within('.calculator-fields') { fill_in "Flat Percent", :with => "10" }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.code.should be_blank

      first_rule = promotion.rules.first
      first_rule.class.should == Colibri::Promotion::Rules::ItemTotal
      first_rule.preferred_amount.should == 30

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateAdjustment
      first_action_calculator = first_action.calculator
      first_action_calculator.class.should == Colibri::Calculator::FlatPercentItemTotal
      first_action_calculator.preferred_flat_percent.should == 10
    end

    it "should allow an admin to create an product promo with percent per item discount" do
      create(:product, :name => "RoR Mug")

      fill_in "Name", :with => "Promotion"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Product(s)", :from => "Add rule of type"
      within("#rule_fields") { click_button "Add" }
      select2_search "RoR Mug", :from => "Choose products"
      within('#rule_fields') { click_button "Update" }

      select2 "Create per-line-item adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Percent Per Item", :from => "Calculator"
      within('#actions_container') { click_button "Update" }
      within('.calculator-fields') { fill_in "Percent", :with => "10" }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.code.should be_blank

      first_rule = promotion.rules.first
      first_rule.class.should == Colibri::Promotion::Rules::Product
      first_rule.products.map(&:name).should include("RoR Mug")

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateItemAdjustments
      first_action_calculator = first_action.calculator
      first_action_calculator.class.should == Colibri::Calculator::PercentOnLineItem
      first_action_calculator.preferred_percent.should == 10
    end

    xit "should allow an admin to create an automatic promotion with free shipping (no code)" do
      fill_in "Name", :with => "Promotion"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Item total", :from => "Add rule of type"
      within('#rule_fields') { click_button "Add" }
      eventually_fill_in "promotion_promotion_rules_attributes_1_preferred_amount", :with => "30"
      within('#rule_fields') { click_button "Update" }

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Free Shipping", :from => "Calculator"
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.code.should be_blank

      first_rule = promotion.rules.first
      first_rule.class.should == Colibri::Promotion::Rules::ItemTotal

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateAdjustment
      first_action_calculator = first_action.calculator
      first_action_calculator.class.should == Colibri::Calculator::FreeShipping
    end

    it "should allow an admin to create an automatic promo requiring a landing page to be visited" do
      fill_in "Name", :with => "Promotion"
      fill_in "Path", :with => "content/cvv"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Flat Rate", :from => "Calculator"
      within('#actions_container') { click_button "Update" }
      within('.calculator-fields') { fill_in "Amount", :with => "4" }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.path.should == "content/cvv"
      promotion.code.should be_blank
      promotion.rules.should be_blank

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateAdjustment
      first_action_calculator = first_action.calculator
      first_action_calculator.class.should == Colibri::Calculator::FlatRate
      first_action_calculator.preferred_amount.should == 4
    end

    it "should allow an admin to create a promotion that adds a 'free' item to the cart" do
      create(:product, :name => "RoR Mug")
      fill_in "Name", :with => "Promotion"
      fill_in "Code", :with => "complex"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Create line items", :from => "Add action of type"

      within('#action_fields') { click_button "Add" }

      page.find('.create_line_items .select2-choice').click
      page.find('.select2-input').set('RoR Mug')
      page.find('.select2-highlighted').click

      within('#actions_container') { click_button "Update" }

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#new_promotion_action_form') { click_button "Add" }
      select2 "Flat Rate", :from => "Calculator"
      within('#actions_container') { click_button "Update" }
      within('.calculator-fields') { fill_in "Amount", :with => "40.00" }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")
      promotion.code.should == "complex"

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateLineItems
      line_item = first_action.promotion_action_line_items.should_not be_empty
    end

    it "ceasing to be eligible for a promotion with item total rule then becoming eligible again" do
      fill_in "Name", :with => "Promotion"
      click_button "Create"
      page.should have_content("Editing Promotion")

      select2 "Item total", :from => "Add rule of type"
      within('#rule_fields') { click_button "Add" }
      eventually_fill_in "promotion_promotion_rules_attributes_1_preferred_amount", :with => "50"
      within('#rule_fields') { click_button "Update" }

      select2 "Create whole-order adjustment", :from => "Add action of type"
      within('#action_fields') { click_button "Add" }
      select2 "Flat Rate", :from => "Calculator"
      within('#actions_container') { click_button "Update" }
      within('.calculator-fields') { fill_in "Amount", :with => "5" }
      within('#actions_container') { click_button "Update" }

      promotion = Colibri::Promotion.find_by_name("Promotion")

      first_rule = promotion.rules.first
      first_rule.class.should == Colibri::Promotion::Rules::ItemTotal
      first_rule.preferred_amount.should == 50

      first_action = promotion.actions.first
      first_action.class.should == Colibri::Promotion::Actions::CreateAdjustment
      first_action.calculator.class.should == Colibri::Calculator::FlatRate
      first_action.calculator.preferred_amount.should == 5
    end
  end
end
