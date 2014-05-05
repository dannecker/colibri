taxonomies = [
  { :name => "Categories" },
  { :name => "Brand" }
]

taxonomies.each do |taxonomy_attrs|
  Colibri::Taxonomy.create!(taxonomy_attrs)
end
