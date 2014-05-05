module Colibri
  class OrderMailer < BaseMailer
    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Colibri::Order.find(order)
      subject = (resend ? "[#{Colibri.t(:resend).upcase}] " : '')
      subject += "#{Colibri::Store.current.name} #{Colibri.t('order_mailer.confirm_email.subject')} ##{@order.number}"
      mail(to: @order.email, from: from_address, subject: subject)
    end

    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Colibri::Order.find(order)
      subject = (resend ? "[#{Colibri.t(:resend).upcase}] " : '')
      subject += "#{Colibri::Store.current.name} #{Colibri.t('order_mailer.cancel_email.subject')} ##{@order.number}"
      mail(to: @order.email, from: from_address, subject: subject)
    end
  end
end
