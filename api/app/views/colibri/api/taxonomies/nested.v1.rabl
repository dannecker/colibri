attributes *taxonomy_attributes

child :root => :root do
  attributes *taxon_attributes

  child :children => :taxons do
    attributes *taxon_attributes

    extends "colibri/api/taxons/taxons"
  end
end
