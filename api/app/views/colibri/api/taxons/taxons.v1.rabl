node do |t|
  child t.children => :taxons do
    attributes *taxon_attributes

    extends "colibri/api/taxons/taxons"
  end
end
