class CreateDefaultStock < ActiveRecord::Migration
  def up
    Colibri::StockLocation.skip_callback(:create, :after, :create_stock_items)
    Colibri::StockItem.skip_callback(:save, :after, :process_backorders)
    location = Colibri::StockLocation.new(name: 'default')
    location.save(validate: false)

    Colibri::Variant.find_each do |variant|
      stock_item = Colibri::StockItem.unscoped.build(stock_location: location, variant: variant)
      stock_item.send(:count_on_hand=, variant.count_on_hand)
      # Avoid running default_scope defined by acts_as_paranoid, related to #3805,
      # validations would run a query with a delete_at column that might not be present yet
      stock_item.save! validate: false
    end

    remove_column :colibri_variants, :count_on_hand
  end

  def down
    add_column :colibri_variants, :count_on_hand, :integer

    Colibri::StockItem.find_each do |stock_item|
      stock_item.variant.update_column :count_on_hand, stock_item.count_on_hand
    end

    Colibri::StockLocation.delete_all
    Colibri::StockItem.delete_all
  end
end

