require 'spec_helper'

module Colibri
  module Admin
    describe PaymentsController do
      stub_authorization!

      let(:order) { create(:order) }

      context "with a valid credit card" do
        it "should process payment correctly" do
          order = create(:order_with_line_items, :state => "payment")
          payment_method = create(:credit_card_payment_method, :display_on => "back_end")
          attributes = {
            :order_id => order.number,
            :card => "new",
            :payment => {
              :amount => order.total,
              :payment_method_id => payment_method.id.to_s,
              :source_attributes => {
                :name => "Test User",
                :number => "4111 1111 1111 1111",
                :expiry => "09 / #{Time.now.year + 1}",
                :verification_value => "123"
              }
            }
          }
          colibri_post :create, attributes
          order.payments.count.should == 1
          expect(response).to redirect_to(colibri.admin_order_payments_path(order))
          expect(order.reload.state).to eq('complete')
        end
      end

      # Regression test for #3233
      context "with a backend payment method" do
        before do
          @payment_method = create(:check_payment_method, :display_on => "back_end")
        end

        it "loads backend payment methods" do
          colibri_get :new, :order_id => order.number
          response.status.should == 200
          assigns[:payment_methods].should include(@payment_method)
        end
      end

      context "order has billing address" do
        before do
          order.bill_address = create(:address)
          order.save!
        end

        context "order does not have payments" do
          it "redirect to new payments page" do
            colibri_get :index, { amount: 100, order_id: order.number }
            response.should redirect_to(colibri.new_admin_order_payment_path(order))
          end
        end

        context "order has payments" do
          before do
            order.payments << create(:payment, amount: order.total, order: order, state: 'completed')
          end

          it "shows the payments page" do
            colibri_get :index, { amount: 100, order_id: order.number }
            expect(response.code).to eq "200"
          end
        end

      end

      context "order does not have a billing address" do
        before do
          order.bill_address = nil
          order.save
        end

        it "should redirect to the customer details page" do
          colibri_get :index, { amount: 100, order_id: order.number }
          expect(response).to redirect_to(colibri.edit_admin_order_customer_path(order))
        end
      end

    end
  end
end
