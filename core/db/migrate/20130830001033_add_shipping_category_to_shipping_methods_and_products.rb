class AddShippingCategoryToShippingMethodsAndProducts < ActiveRecord::Migration
  def up
    default_category = Colibri::ShippingCategory.first
    default_category ||= Colibri::ShippingCategory.create!(:name => "Default")

    Colibri::ShippingMethod.all.each do |method|
      method.shipping_categories << default_category if method.shipping_categories.blank?
    end

    Colibri::Product.where(shipping_category_id: nil).update_all(shipping_category_id: default_category.id)
  end

  def down
  end
end
