# coding: utf-8
require 'spec_helper'

describe Colibri::Money do
  before do
    configure_colibri_preferences do |config|
      config.currency = "USD"
      config.currency_symbol_position = :before
      config.display_currency = false
    end
  end

  it "formats correctly" do
    money = Colibri::Money.new(10)
    money.to_s.should == "$10.00"
  end

  it "can get cents" do
    money = Colibri::Money.new(10)
    money.cents.should == 1000
  end

  context "with currency" do
    it "passed in option" do
      money = Colibri::Money.new(10, :with_currency => true, :html => false)
      money.to_s.should == "$10.00 USD"
    end

    it "config option" do
      Colibri::Config[:display_currency] = true
      money = Colibri::Money.new(10, :html => false)
      money.to_s.should == "$10.00 USD"
    end
  end

  context "hide cents" do
    it "hides cents suffix" do
      Colibri::Config[:hide_cents] = true
      money = Colibri::Money.new(10)
      money.to_s.should == "$10"
    end

    it "shows cents suffix" do
      Colibri::Config[:hide_cents] = false
      money = Colibri::Money.new(10)
      money.to_s.should == "$10.00"
    end
  end

  context "currency parameter" do
    context "when currency is specified in Canadian Dollars" do
      it "uses the currency param over the global configuration" do
        money = Colibri::Money.new(10, :currency => 'CAD', :with_currency => true, :html => false)
        money.to_s.should == "$10.00 CAD"
      end
    end

    context "when currency is specified in Japanese Yen" do
      it "uses the currency param over the global configuration" do
        money = Colibri::Money.new(100, :currency => 'JPY', :html => false)
        money.to_s.should == "¥100"
      end
    end
  end

  context "symbol positioning" do
    it "passed in option" do
      money = Colibri::Money.new(10, :symbol_position => :after, :html => false)
      money.to_s.should == "10.00 $"
    end

    it "passed in option string" do
      money = Colibri::Money.new(10, :symbol_position => "after", :html => false)
      money.to_s.should == "10.00 $"
    end

    it "config option" do
      Colibri::Config[:currency_symbol_position] = :after
      money = Colibri::Money.new(10, :html => false)
      money.to_s.should == "10.00 $"
    end
  end

  context "sign before symbol" do
    it "defaults to -$10.00" do
      money = Colibri::Money.new(-10)
      money.to_s.should == "-$10.00"
    end

    it "passed in option" do
      money = Colibri::Money.new(-10, :sign_before_symbol => false)
      money.to_s.should == "$-10.00"
    end

    it "config option" do
      Colibri::Config[:currency_sign_before_symbol] = false
      money = Colibri::Money.new(-10)
      money.to_s.should == "$-10.00"
    end
  end

  context "JPY" do
    before do
      configure_colibri_preferences do |config|
        config.currency = "JPY"
        config.currency_symbol_position = :before
        config.display_currency = false
      end
    end

    it "formats correctly" do
      money = Colibri::Money.new(1000, :html => false)
      money.to_s.should == "¥1,000"
    end
  end

  context "EUR" do
    before do
      configure_colibri_preferences do |config|
        config.currency = "EUR"
        config.currency_symbol_position = :after
        config.display_currency = false
      end
    end

    # Regression test for #2634
    it "formats as plain by default" do
      money = Colibri::Money.new(10)
      money.to_s.should == "10.00 €"
    end

    # Regression test for #2632
    it "acknowledges decimal mark option" do
      Colibri::Config[:currency_decimal_mark] = ","
      money = Colibri::Money.new(10)
      money.to_s.should == "10,00 €"
    end

    # Regression test for #2632
    it "acknowledges thousands separator option" do
      Colibri::Config[:currency_thousands_separator] = "."
      money = Colibri::Money.new(1000)
      money.to_s.should == "1.000.00 €"
    end

    it "formats as HTML if asked (nicely) to" do
      money = Colibri::Money.new(10)
      # The HTML'ified version of "10.00 €"
      money.to_html.should == "10.00&nbsp;&#x20AC;"
    end

    it "formats as HTML with currency" do
      Colibri::Config[:display_currency] = true
      money = Colibri::Money.new(10)
      # The HTML'ified version of "10.00 €"
      money.to_html.should == "10.00&nbsp;&#x20AC; <span class=\"currency\">EUR</span>"
    end
  end

  describe "#as_json" do
    let(:options) { double('options') }

    it "returns the expected string" do
      money = Colibri::Money.new(10)
      money.as_json(options).should == "$10.00"
    end
  end
end
