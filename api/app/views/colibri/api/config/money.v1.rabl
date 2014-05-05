object false
node(:symbol) { ::Money.new(1, Colibri::Config[:currency]).symbol }
node(:symbol_position) { Colibri::Config[:currency_symbol_position] }
node(:no_cents) { Colibri::Config[:hide_cents] }
node(:decimal_mark) { Colibri::Config[:currency_decimal_mark] }
node(:thousands_separator) { Colibri::Config[:currency_thousands_separator] }
