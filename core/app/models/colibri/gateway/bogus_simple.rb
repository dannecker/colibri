# Bogus Gateway that doesn't support payment profiles
module Colibri
  class Gateway::BogusSimple < Gateway::Bogus

    def payment_profiles_supported?
      false
    end

    def authorize(money, credit_card, options = {})
      if VALID_CCS.include? credit_card.number
        ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, :test => true, :authorization => '12345', :avs_result => { :code => 'A' })
      else
        ActiveMerchant::Billing::Response.new(false, 'Bogus Gateway: Forced failure', { :message => 'Bogus Gateway: Forced failure' }, :test => true)
      end
    end

    def purchase(money, credit_card, options = {})
      if VALID_CCS.include? credit_card.number
        ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, :test => true, :authorization => '12345', :avs_result => { :code => 'A' })
      else
        ActiveMerchant::Billing::Response.new(false, 'Bogus Gateway: Forced failure', :message => 'Bogus Gateway: Forced failure', :test => true)
      end
    end

  end
end
