object @stock_item
attributes *stock_item_attributes
child(:variant) do
  extends "colibri/api/variants/small"
end
