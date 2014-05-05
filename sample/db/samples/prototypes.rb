prototypes = [
  {
    :name => "Shirt",
    :properties => ["Manufacturer", "Brand", "Model", "Shirt Type", "Sleeve Type", "Material", "Fit", "Gender"]
  },
  {
    :name => "Bag",
    :properties => ["Type", "Size", "Material"]
  },
  {
    :name => "Mugs",
    :properties => ["Size", "Type"]
  }
]

prototypes.each do |prototype_attrs|
  prototype = Colibri::Prototype.create!(:name => prototype_attrs[:name])
  prototype_attrs[:properties].each do |property|
    prototype.properties << Colibri::Property.find_by_name!(property)
  end
end
