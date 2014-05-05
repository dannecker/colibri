module Colibri
  class BaseMailer < ActionMailer::Base
    def from_address
      Colibri::Config[:mails_from]
    end

    def money(amount)
      Colibri::Money.new(amount).to_s
    end
    helper_method :money

    def mail(headers={}, &block)
      super if Colibri::Config[:send_core_emails]
    end

  end
end
