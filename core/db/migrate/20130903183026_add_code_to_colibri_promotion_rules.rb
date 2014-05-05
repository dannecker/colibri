class AddCodeToColibriPromotionRules < ActiveRecord::Migration
  def change
    add_column :colibri_promotion_rules, :code, :string
  end
end
