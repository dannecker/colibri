object @taxonomy

if set = params[:set]
  extends "colibri/api/taxonomies/#{set}"
else
  attributes *taxonomy_attributes

  child :root => :root do
      attributes *taxon_attributes

    child :children => :taxons do
      attributes *taxon_attributes
    end
  end
end
