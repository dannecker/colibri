object false
child(@users => :users) do
  extends "colibri/api/users/show"
end
node(:count) { @users.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @users.num_pages }
