require 'spec_helper'
require 'email_spec'

describe Colibri::OrderMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:order) do
    order = stub_model(Colibri::Order)
    product = stub_model(Colibri::Product, :name => %Q{The "BEST" product})
    variant = stub_model(Colibri::Variant, :product => product)
    price = stub_model(Colibri::Price, :variant => variant, :amount => 5.00)
    line_item = stub_model(Colibri::LineItem, :variant => variant, :order => order, :quantity => 1, :price => 4.99)
    variant.stub(:default_price => price)
    order.stub(:line_items => [line_item])
    order
  end

  context ":from not set explicitly" do
    it "falls back to colibri config" do
      message = Colibri::OrderMailer.confirm_email(order)
      message.from.should == [Colibri::Config[:mails_from]]
    end
  end

  it "doesn't aggressively escape double quotes in confirmation body" do
    confirmation_email = Colibri::OrderMailer.confirm_email(order)
    confirmation_email.body.should_not include("&quot;")
  end

  it "confirm_email accepts an order id as an alternative to an Order object" do
    Colibri::Order.should_receive(:find).with(order.id).and_return(order)
    lambda {
      confirmation_email = Colibri::OrderMailer.confirm_email(order.id)
    }.should_not raise_error
  end

  it "cancel_email accepts an order id as an alternative to an Order object" do
    Colibri::Order.should_receive(:find).with(order.id).and_return(order)
    lambda {
      cancel_email = Colibri::OrderMailer.cancel_email(order.id)
    }.should_not raise_error
  end

  context "only shows eligible adjustments in emails" do
    before do
      create(:adjustment, :order => order, :eligible => true, :label => "Eligible Adjustment")
      create(:adjustment, :order => order, :eligible => false, :label => "Ineligible Adjustment")
    end

    let!(:confirmation_email) { Colibri::OrderMailer.confirm_email(order) }
    let!(:cancel_email) { Colibri::OrderMailer.cancel_email(order) }

    specify do
      confirmation_email.body.should_not include("Ineligible Adjustment")
    end

    specify do
      cancel_email.body.should_not include("Ineligible Adjustment")
    end
  end

  context "displays unit costs from line item" do
    # Regression test for #2772

    # Tests mailer view colibri/order_mailer/confirm_email.text.erb
    specify do
      confirmation_email = Colibri::OrderMailer.confirm_email(order)
      confirmation_email.body.should include("4.99")
      confirmation_email.body.should_not include("5.00")
    end

    # Tests mailer view colibri/order_mailer/cancel_email.text.erb
    specify do
      cancel_email = Colibri::OrderMailer.cancel_email(order)
      cancel_email.body.should include("4.99")
      cancel_email.body.should_not include("5.00")
    end
  end

  context "emails must be translatable" do

    context "pt-BR locale" do
      before do
        pt_br_confirm_mail = { :colibri => { :order_mailer => { :confirm_email => { :dear_customer => 'Caro Cliente,' } } } }
        pt_br_cancel_mail = { :colibri => { :order_mailer => { :cancel_email => { :order_summary_canceled => 'Resumo da Pedido [CANCELADA]' } } } }
        I18n.backend.store_translations :'pt-BR', pt_br_confirm_mail
        I18n.backend.store_translations :'pt-BR', pt_br_cancel_mail
        I18n.locale = :'pt-BR'
      end

      after do
        I18n.locale = I18n.default_locale
      end

      context "confirm_email" do
        specify do
          confirmation_email = Colibri::OrderMailer.confirm_email(order)
          confirmation_email.body.should include("Caro Cliente,")
        end
      end

      context "cancel_email" do
        specify do
          cancel_email = Colibri::OrderMailer.cancel_email(order)
          cancel_email.body.should include("Resumo da Pedido [CANCELADA]")
        end
      end
    end
  end

  context "with preference :send_core_emails set to false" do
    it "sends no email" do
      Colibri::Config.set(:send_core_emails, false)
      message = Colibri::OrderMailer.confirm_email(order)
      message.body.should be_blank
    end
  end

end
