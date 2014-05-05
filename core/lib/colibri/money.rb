# encoding: utf-8

require 'money'

module Colibri
  class Money
    attr_reader :money

    delegate :cents, :to => :money

    def initialize(amount, options={})
      @money = Monetize.parse([amount, (options[:currency] || Colibri::Config[:currency])].join)
      @options = {}
      @options[:with_currency] = Colibri::Config[:display_currency]
      @options[:symbol_position] = Colibri::Config[:currency_symbol_position].to_sym
      @options[:no_cents] = Colibri::Config[:hide_cents]
      @options[:decimal_mark] = Colibri::Config[:currency_decimal_mark]
      @options[:thousands_separator] = Colibri::Config[:currency_thousands_separator]
      @options[:sign_before_symbol] = Colibri::Config[:currency_sign_before_symbol]
      @options.merge!(options)
      # Must be a symbol because the Money gem doesn't do the conversion
      @options[:symbol_position] = @options[:symbol_position].to_sym
    end

    def to_s
      @money.format(@options)
    end

    def to_html(options = { :html => true })
      output = @money.format(@options.merge(options))
      if options[:html]
        # 1) prevent blank, breaking spaces
        # 2) prevent escaping of HTML character entities
        output = output.sub(" ", "&nbsp;").html_safe
      end
      output
    end

    def as_json(*)
      to_s
    end

    def ==(obj)
      @money == obj.money
    end
  end
end
