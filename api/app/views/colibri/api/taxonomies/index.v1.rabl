object false
child(@taxonomies => :taxonomies) do
  extends "colibri/api/taxonomies/show"
end
node(:count) { @taxonomies.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @taxonomies.num_pages }
