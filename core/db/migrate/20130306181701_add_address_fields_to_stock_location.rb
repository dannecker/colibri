class AddAddressFieldsToStockLocation < ActiveRecord::Migration
  def change
    remove_column :colibri_stock_locations, :address_id

    add_column :colibri_stock_locations, :address1, :string
    add_column :colibri_stock_locations, :address2, :string
    add_column :colibri_stock_locations, :city, :string
    add_column :colibri_stock_locations, :state_id, :integer
    add_column :colibri_stock_locations, :state_name, :string
    add_column :colibri_stock_locations, :country_id, :integer
    add_column :colibri_stock_locations, :zipcode, :string
    add_column :colibri_stock_locations, :phone, :string


    usa = Colibri::Country.where(:iso => 'US').first
    # In case USA isn't found.
    # See #3115
    country = usa || Colibri::Country.first
    Colibri::Country.reset_column_information
    Colibri::StockLocation.update_all(:country_id => country)
  end
end
