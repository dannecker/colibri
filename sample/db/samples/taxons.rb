Colibri::Sample.load_sample("taxonomies")
Colibri::Sample.load_sample("products")

categories = Colibri::Taxonomy.find_by_name!("Categories")
brands = Colibri::Taxonomy.find_by_name!("Brand")

products = { 
  :ror_tote => "Ruby on Rails Tote",
  :ror_bag => "Ruby on Rails Bag",
  :ror_mug => "Ruby on Rails Mug",
  :ror_stein => "Ruby on Rails Stein",
  :ror_baseball_jersey => "Ruby on Rails Baseball Jersey",
  :ror_jr_spaghetti => "Ruby on Rails Jr. Spaghetti",
  :ror_ringer => "Ruby on Rails Ringer T-Shirt",
  :colibri_stein => "Colibri Stein",
  :colibri_mug => "Colibri Mug",
  :colibri_ringer => "Colibri Ringer T-Shirt",
  :colibri_baseball_jersey =>  "Colibri Baseball Jersey",
  :colibri_tote => "Colibri Tote",
  :colibri_bag => "Colibri Bag",
  :colibri_jr_spaghetti => "Colibri Jr. Spaghetti",
  :apache_baseball_jersey => "Apache Baseball Jersey",
  :ruby_baseball_jersey => "Ruby Baseball Jersey",
}


products.each do |key, name|
  products[key] = Colibri::Product.find_by_name!(name)
end

taxons = [
  {
    :name => "Categories",
    :taxonomy => categories,
    :position => 0
  },
  {
    :name => "Bags",
    :taxonomy => categories,
    :parent => "Categories",
    :position => 1,
    :products => [
      products[:ror_tote],
      products[:ror_bag],
      products[:colibri_tote],
      products[:colibri_bag]
    ]
  },
  {
    :name => "Mugs",
    :taxonomy => categories,
    :parent => "Categories",
    :position => 2,
    :products => [
      products[:ror_mug],
      products[:ror_stein],
      products[:colibri_stein],
      products[:colibri_mug]
    ]
  },
  {
    :name => "Clothing",
    :taxonomy => categories,
    :parent => "Categories" 
  },
  {
    :name => "Shirts",
    :taxonomy => categories,
    :parent => "Clothing",
    :position => 0,
    :products => [
      products[:ror_jr_spaghetti],
      products[:colibri_jr_spaghetti]
    ]
  },
  {
    :name => "T-Shirts",
    :taxonomy => categories,
    :parent => "Clothing" ,
    :products => [
      products[:ror_baseball_jersey],
      products[:ror_ringer],
      products[:apache_baseball_jersey],
      products[:ruby_baseball_jersey],
      products[:colibri_baseball_jersey],
      products[:colibri_ringer]
    ],
    :position => 0
  },
  {
    :name => "Brands",
    :taxonomy => brands
  },
  {
    :name => "Ruby",
    :taxonomy => brands,
    :parent => "Brand",
    :products => [
      products[:ruby_baseball_jersey]
    ]
  },
  {
    :name => "Apache",
    :taxonomy => brands,
    :parent => "Brand",
    :products => [
      products[:apache_baseball_jersey]
    ]
  },
  {
    :name => "Colibri",
    :taxonomy => brands,
    :parent => "Brand",
    :products => [
      products[:colibri_stein],
      products[:colibri_mug],
      products[:colibri_ringer],
      products[:colibri_baseball_jersey],
      products[:colibri_tote],
      products[:colibri_bag],
      products[:colibri_jr_spaghetti],
    ]
  },
  {
    :name => "Rails",
    :taxonomy => brands,
    :parent => "Brand",
    :products => [
      products[:ror_tote],
      products[:ror_bag],
      products[:ror_mug],
      products[:ror_stein],
      products[:ror_baseball_jersey],
      products[:ror_jr_spaghetti],
      products[:ror_ringer],
    ]
  },
]

taxons.each do |taxon_attrs|
  if taxon_attrs[:parent]
    taxon_attrs[:parent] = Colibri::Taxon.find_by_name!(taxon_attrs[:parent])
    Colibri::Taxon.create!(taxon_attrs)
  end
end
