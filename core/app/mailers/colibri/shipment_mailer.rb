module Colibri
  class ShipmentMailer < BaseMailer
    def shipped_email(shipment, resend = false)
      @shipment = shipment.respond_to?(:id) ? shipment : Colibri::Shipment.find(shipment)
      subject = (resend ? "[#{Colibri.t(:resend).upcase}] " : '')
      subject += "#{Colibri::Store.current.name} #{Colibri.t('shipment_mailer.shipped_email.subject')} ##{@shipment.order.number}"
      mail(to: @shipment.order.email, from: from_address, subject: subject)
    end
  end
end
