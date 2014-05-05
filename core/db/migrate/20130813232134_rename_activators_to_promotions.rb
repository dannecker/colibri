class RenameActivatorsToPromotions < ActiveRecord::Migration
  def change
    rename_table :colibri_activators, :colibri_promotions
  end
end
