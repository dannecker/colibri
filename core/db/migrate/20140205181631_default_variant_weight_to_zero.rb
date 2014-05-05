class DefaultVariantWeightToZero < ActiveRecord::Migration
  def up
    Colibri::Variant.unscoped.where(weight: nil).update_all("weight = 0.0")

    change_column :colibri_variants, :weight, :decimal, precision: 8, scale: 2, default: 0.0
  end

  def down
    change_column :colibri_variants, :weight, :decimal, precision: 8, scale: 2
  end
end
