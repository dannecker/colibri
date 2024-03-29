require 'spec_helper'

describe "Coupon code promotions", :js => true do
  let!(:country) { create(:country, :name => "United States of America", :states_required => true) }
  let!(:state) { create(:state, :name => "Alabama", :country => country) }
  let!(:zone) { create(:zone) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:product) { create(:product, :name => "RoR Mug", :price => 20) }

  context "visitor makes checkout as guest without registration" do
    def create_basic_coupon_promotion(code)
      promotion = Colibri::Promotion.create!(:name       => code.titleize,
                                           :code       => code,
                                           :starts_at  => 1.day.ago,
                                           :expires_at => 1.day.from_now)

     calculator = Colibri::Calculator::FlatRate.new
     calculator.preferred_amount = 10

     action = Colibri::Promotion::Actions::CreateItemAdjustments.new
     action.calculator = calculator
     action.promotion = promotion
     action.save

     promotion.reload # so that promotion.actions is available
   end

    let!(:promotion) { create_basic_coupon_promotion("onetwo") }

    # OrdersController
    context "on the payment page" do
      before do

        visit colibri.root_path
        click_link "RoR Mug"
        click_button "add-to-cart-button"
        click_button "Checkout"
        fill_in "order_email", :with => "colibri@example.com"
        fill_in "First Name", :with => "John"
        fill_in "Last Name", :with => "Smith"
        fill_in "Street Address", :with => "1 John Street"
        fill_in "City", :with => "City of John"
        fill_in "Zip", :with => "01337"
        select country.name, :from => "Country"
        select state.name, :from => "order[bill_address_attributes][state_id]"
        fill_in "Phone", :with => "555-555-5555"

        # To shipping method screen
        click_button "Save and Continue"
        # To payment screen
        click_button "Save and Continue"
      end

      it "informs about an invalid coupon code" do
        fill_in "order_coupon_code", :with => "coupon_codes_rule_man"
        click_button "Save and Continue"
        page.should have_content(Colibri.t(:coupon_code_not_found))
      end

      it "can enter an invalid coupon code, then a real one" do
        fill_in "order_coupon_code", :with => "coupon_codes_rule_man"
        click_button "Save and Continue"
        page.should have_content(Colibri.t(:coupon_code_not_found))
        fill_in "order_coupon_code", :with => "onetwo"
        click_button "Save and Continue"
        page.should have_content("Promotion (Onetwo)   -$10.00")
      end

      context "with a promotion" do
        it "applies a promotion to an order" do
          fill_in "order_coupon_code", :with => "onetwo"
          click_button "Save and Continue"
          page.should have_content("Promotion (Onetwo)   -$10.00")
        end
      end
    end

    # CheckoutController
    context "on the cart page" do

      before do
        visit colibri.root_path
        click_link "RoR Mug"
        click_button "add-to-cart-button"
      end

      it "can enter a coupon code and receives success notification" do
        fill_in "order_coupon_code", :with => "onetwo"
        click_button "Update"
        page.should have_content(Colibri.t(:coupon_code_applied))
      end

      it "can enter a promotion code with both upper and lower case letters" do
        fill_in "order_coupon_code", :with => "ONETwO"
        click_button "Update"
        page.should have_content(Colibri.t(:coupon_code_applied))
      end

      it "informs the user about a coupon code which has exceeded its usage" do
        promotion.update_column(:usage_limit, 5)
        promotion.class.any_instance.stub(:credits_count => 10)

        fill_in "order_coupon_code", :with => "onetwo"
        click_button "Update"
        page.should have_content(Colibri.t(:coupon_code_max_usage))
      end

      context "informs the user if the coupon code is not eligible" do
        before do
          rule = Colibri::Promotion::Rules::ItemTotal.new
          rule.promotion = promotion
          rule.preferred_amount = 100
          rule.save
        end

        specify do
          visit colibri.cart_path

          fill_in "order_coupon_code", :with => "onetwo"
          click_button "Update"
          page.should have_content(Colibri.t(:coupon_code_not_eligible))
        end
      end

      it "informs the user if the coupon is expired" do
        promotion.expires_at = Date.today.beginning_of_week
        promotion.starts_at = Date.today.beginning_of_week.advance(:day => 3)
        promotion.save!
        fill_in "order_coupon_code", :with => "onetwo"
        click_button "Update"
        page.should have_content(Colibri.t(:coupon_code_expired))
      end

      context "calculates the correct amount of money saved with flat percent promotions" do
        before do
          calculator = Colibri::Calculator::FlatPercentItemTotal.new
          calculator.preferred_flat_percent = 20
          promotion.actions.first.calculator = calculator
          promotion.save

          create(:product, :name => "Colibri Mug", :price => 10)
        end

        specify do
          visit colibri.root_path
          click_link "Colibri Mug"
          click_button "add-to-cart-button"

          visit colibri.cart_path
          fill_in "order_coupon_code", :with => "onetwo"
          click_button "Update"

          fill_in "order_line_items_attributes_0_quantity", :with => 2
          fill_in "order_line_items_attributes_1_quantity", :with => 2
          click_button "Update"


          within '#cart_adjustments' do
            # 20% of $40 = 8
            # 20% of $20 = 4
            # Therefore: promotion discount amount is $12.
            page.should have_content("Promotion (Onetwo) -$12.00")
          end

          within '.cart-total' do
            page.should have_content("$48.00")
          end
        end
      end
    end
  end
end
