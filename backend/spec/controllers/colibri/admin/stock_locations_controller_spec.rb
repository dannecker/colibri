require 'spec_helper'

module Colibri
  module Admin
    describe StockLocationsController do
      stub_authorization!
      
      # Regression for #4272
      context "with no countries present" do
        it "cannot create a new stock location" do
          colibri_get :new
          expect(flash[:error]).to eq(Colibri.t(:stock_locations_need_a_default_country))
          expect(response).to redirect_to(colibri.admin_stock_locations_path)
        end
      end

      context "with a default country present" do
        before do
          country = FactoryGirl.create(:country)
          Colibri::Config[:default_country_id] = country.id
        end

        it "can create a new stock location" do
          colibri_get :new
          response.should be_success
        end
      end

      context "with a country with the ISO code of 'US' existing" do
        before do
          FactoryGirl.create(:country, iso: 'US')
        end

        it "can create a new stock location" do
          colibri_get :new
          response.should be_success
        end 
      end
    end
  end
end
