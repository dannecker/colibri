object false
child(@zones => :zones) do
  extends 'colibri/api/zones/show'
end
node(:count) { @zones.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @zones.num_pages }
