class AddUpdatedAtToVariants < ActiveRecord::Migration
  def change
    add_column :colibri_variants, :updated_at, :datetime
  end
end
