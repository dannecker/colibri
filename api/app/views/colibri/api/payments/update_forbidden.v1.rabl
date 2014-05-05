object false
node(:error) { I18n.t(:update_forbidden, :state => @payment.state, :scope => 'colibri.api.payment') }
