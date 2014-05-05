//= require jquery.payment
//= require_self
//= require colibri/frontend/checkout/address
//= require colibri/frontend/checkout/payment

Colibri.disableSaveOnClick = ->
  ($ 'form.edit_order').submit ->
    ($ this).find(':submit, :image').attr('disabled', true).removeClass('primary').addClass 'disabled'

Colibri.ready ($) ->
  Colibri.Checkout = {}
