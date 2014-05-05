object @line_item
cache @line_item
attributes *line_item_attributes
node(:single_display_amount) { |li| li.single_display_amount.to_s }
node(:display_amount) { |li| li.display_amount.to_s }
node(:total) { |li| li.total }
child :variant do
  extends "colibri/api/variants/small"
  attributes :product_id
  child(:images => :images) { extends "colibri/api/images/show" }
end

child :adjustments => :adjustments do
  extends "colibri/api/adjustments/show"
end
