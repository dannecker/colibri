module Colibri
  class TestMailer < BaseMailer
    def test_email(user)
      recipient = user.respond_to?(:id) ? user : Colibri.user_class.find(user)
      subject = "#{Colibri::Store.current.name} #{Colibri.t('test_mailer.test_email.subject')}"
      mail(to: recipient.email, from: from_address, subject: subject)
    end
  end
end
