require 'spec_helper'

module Colibri
  describe "Countries" do
    stub_authorization!

    it "deletes a state", js: true do
      visit colibri.admin_countries_path
      click_link "New Country"

      fill_in "Name", with: "Brazil"
      fill_in "Iso Name", with: "BRL"
      click_button "Create"

      accept_alert do
        click_icon :trash
      end
      wait_for_ajax

      expect { Country.find(country.id) }.to raise_error
    end
  end
end
