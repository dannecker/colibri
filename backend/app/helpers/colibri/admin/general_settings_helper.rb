module Colibri
  module Admin
    module GeneralSettingsHelper
      def currency_options
        currencies = ::Money::Currency.table.map do |code, details|
          iso = details[:iso_code]
          [iso, "#{details[:name]} (#{iso})"]
        end
        options_from_collection_for_select(currencies, :first, :last, Colibri::Config[:currency])
      end
    end
  end
end
