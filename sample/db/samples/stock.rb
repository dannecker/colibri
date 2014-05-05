Colibri::Sample.load_sample("variants")

location = Colibri::StockLocation.first_or_create! name: 'default'
location.active = true
location.country =  Colibri::Country.where(iso: 'US').first
location.save!

Colibri::Variant.all.each do |variant|
  variant.stock_items.each do |stock_item|
    Colibri::StockMovement.create(:quantity => 10, :stock_item => stock_item)
  end
end
