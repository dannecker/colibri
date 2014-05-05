module Colibri
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Colibri
      engine_name 'colibri'

      initializer "colibri.environment", :before => :load_config_initializers do |app|
        app.config.colibri = Colibri::Core::Environment.new
        Colibri::Config = app.config.colibri.preferences #legacy access
      end

      initializer "colibri.register.calculators" do |app|
        app.config.colibri.calculators.shipping_methods = [
            Colibri::Calculator::Shipping::FlatPercentItemTotal,
            Colibri::Calculator::Shipping::FlatRate,
            Colibri::Calculator::Shipping::FlexiRate,
            Colibri::Calculator::Shipping::PerItem,
            Colibri::Calculator::Shipping::PriceSack]

         app.config.colibri.calculators.tax_rates = [
            Colibri::Calculator::DefaultTax]
      end

      initializer "colibri.register.stock_splitters" do |app|
        app.config.colibri.stock_splitters = [
          Colibri::Stock::Splitter::ShippingCategory,
          Colibri::Stock::Splitter::Backordered
        ]
      end

      initializer "colibri.register.payment_methods" do |app|
        app.config.colibri.payment_methods = [
            Colibri::Gateway::Bogus,
            Colibri::Gateway::BogusSimple,
            Colibri::PaymentMethod::Check ]
      end

      # We need to define promotions rules here so extensions and existing apps
      # can add their custom classes on their initializer files
      initializer 'colibri.promo.environment' do |app|
        app.config.colibri.add_class('promotions')
        app.config.colibri.promotions = Colibri::Promo::Environment.new
        app.config.colibri.promotions.rules = []
      end

      initializer 'colibri.promo.register.promotion.calculators' do |app|
        app.config.colibri.calculators.add_class('promotion_actions_create_adjustments')
        app.config.colibri.calculators.promotion_actions_create_adjustments = [
          Colibri::Calculator::FlatPercentItemTotal,
          Colibri::Calculator::FlatRate,
          Colibri::Calculator::FlexiRate
        ]

        app.config.colibri.calculators.add_class('promotion_actions_create_item_adjustments')
        app.config.colibri.calculators.promotion_actions_create_item_adjustments = [
          Colibri::Calculator::PercentOnLineItem
        ]
      end

      # Promotion rules need to be evaluated on after initialize otherwise
      # Colibri.user_class would be nil and users might experience errors related
      # to malformed model associations (Colibri.user_class is only defined on
      # the app initializer)
      config.after_initialize do
        Rails.application.config.colibri.promotions.rules.concat [
          Colibri::Promotion::Rules::ItemTotal,
          Colibri::Promotion::Rules::Product,
          Colibri::Promotion::Rules::User,
          Colibri::Promotion::Rules::FirstOrder,
          Colibri::Promotion::Rules::UserLoggedIn]
      end

      initializer 'colibri.promo.register.promotions.actions' do |app|
        app.config.colibri.promotions.actions = [
          Promotion::Actions::CreateAdjustment,
          Promotion::Actions::CreateItemAdjustments,
          Promotion::Actions::CreateLineItems,
          Promotion::Actions::FreeShipping]
      end

      # filter sensitive information during logging
      initializer "colibri.params.filter" do |app|
        app.config.filter_parameters += [
          :password,
          :password_confirmation,
          :number,
          :verification_value]
      end

      initializer "colibri.core.checking_migrations" do |app|
        Migrations.new(config, engine_name).check
      end
    end
  end
end

require 'colibri/core/routes'
