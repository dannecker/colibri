$('#order_tab_summary h5#order_status').html('<%= j Colibri.t(:status) %>: <%= j Colibri.t(@order.state, :scope => :order_state) %>');
$('#order_tab_summary h5#order_total').html('<%= j Colibri.t(:total) %>: <%= j @order.display_total.to_html %>');

<% if @order.completed? %>
  $('#order_tab_summary h5#payment_status').html('<%= j Colibri.t(:payment) %>: <%= j Colibri.t(@order.payment_state, :scope => :payment_states, :default => [:missing, "none"]) %>');
  $('#order_tab_summary h5#shipment_status').html('<%= j Colibri.t(:shipment) %>: <%= j Colibri.t(@order.shipment_state, :scope => :shipment_state, :default => [:missing, "none"]) %>');
<% end %>
