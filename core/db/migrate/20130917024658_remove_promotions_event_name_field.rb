class RemovePromotionsEventNameField < ActiveRecord::Migration
  def change
    remove_column :colibri_promotions, :event_name
  end
end
