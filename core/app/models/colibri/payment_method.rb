module Colibri
  class PaymentMethod < Colibri::Base
    acts_as_paranoid
    DISPLAY = [:both, :front_end, :back_end]
    default_scope -> { where(deleted_at: nil) }

    scope :production, -> { where(environment: 'production') }

    validates :name, presence: true

    has_many :payments, class_name: "Colibri::Payment"
    has_many :credit_cards, class_name: "Colibri::CreditCard"

    def self.providers
      Rails.application.config.colibri.payment_methods
    end

    def provider_class
      raise 'You must implement provider_class method for this gateway.'
    end

    # The class that will process payments for this payment type, used for @payment.source
    # e.g. CreditCard in the case of a the Gateway payment type
    # nil means the payment method doesn't require a source e.g. check
    def payment_source_class
      raise 'You must implement payment_source_class method for this gateway.'
    end

    def self.available(display_on = 'both')
      all.select do |p|
        p.active &&
        (p.display_on == display_on.to_s || p.display_on.blank?) &&
        (p.environment == Rails.env || p.environment.blank?)
      end
    end

    def self.active?
      where(type: self.to_s, environment: Rails.env, active: true).count > 0
    end

    def method_type
      type.demodulize.downcase
    end

    def self.find_with_destroyed *args
      unscoped { find(*args) }
    end

    def payment_profiles_supported?
      false
    end

    def source_required?
      true
    end

    # Custom gateways should redefine this method. See Gateway implementation
    # as an example
    def reusable_sources(order)
      []
    end

    def auto_capture?
      self.auto_capture.nil? ? Colibri::Config[:auto_capture] : self.auto_capture
    end

    def supports?(source)
      true
    end
  end
end
