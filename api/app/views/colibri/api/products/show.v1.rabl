object @product
cache [current_currency, root_object]
attributes *product_attributes
node(:display_price) { |p| p.display_price.to_s }
node(:has_variants) { |p| p.has_variants? }
child :master => :master do
  extends "colibri/api/variants/small"
end

child :variants => :variants do
  extends "colibri/api/variants/small"
end

child :option_types => :option_types do
  attributes *option_type_attributes
end

child :product_properties => :product_properties do
  attributes *product_property_attributes
end
