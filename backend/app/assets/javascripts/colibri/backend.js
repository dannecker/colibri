//= require jquery
//= require jquery_ujs
//= require jquery-migrate-1.0.0
//= require jquery.ui.datepicker
//= require jquery.ui.sortable
//= require jquery.ui.autocomplete
//= require modernizr
//= require jquery.cookie
//= require jquery.delayedobserver
//= require jquery.jstree/jquery.jstree
//= require jquery.alerts/jquery.alerts
//= require jquery.powertip
//= require jquery.vAlign
//= require css_browser_selector_dev
//= require spin
//= require trunk8
//= require jquery.adaptivemenu
//= require equalize
//= require responsive-tables
//= require colibri
//= require colibri/backend/colibri-select2
//= require_tree .


Colibri.routes.checkouts_api = Colibri.pathFor('api/checkouts')
Colibri.routes.classifications_api = Colibri.pathFor('api/classifications')
Colibri.routes.option_type_search = Colibri.pathFor('api/option_types')
Colibri.routes.orders_api = Colibri.pathFor('api/orders')
Colibri.routes.product_search = Colibri.pathFor('api/products')
Colibri.routes.shipments_api = Colibri.pathFor('api/shipments')
Colibri.routes.stock_locations_api = Colibri.pathFor('api/stock_locations')
Colibri.routes.taxon_products_api = Colibri.pathFor('api/taxons/products')
Colibri.routes.taxons_search = Colibri.pathFor('api/taxons')
Colibri.routes.user_search = Colibri.pathFor('admin/search/users')
Colibri.routes.variants_api = Colibri.pathFor('api/variants')

Colibri.routes.payments_api = function(order_id) {
  return Colibri.pathFor('api/orders/' + order_id + '/payments')
}

Colibri.routes.stock_items_api = function(stock_location_id) {
  return Colibri.pathFor('api/stock_locations/' + stock_location_id + '/stock_items')
}
