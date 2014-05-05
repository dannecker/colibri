object false
node(:error) { I18n.t(:could_not_transition, :scope => "colibri.api.order") }
node(:errors) { @order.errors.to_hash }
