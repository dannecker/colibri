module Colibri
  class Payment < Colibri::Base
    include Colibri::Payment::Processing

    IDENTIFIER_CHARS = (('A'..'Z').to_a + ('0'..'9').to_a - %w(0 1 I O)).freeze

    belongs_to :order, class_name: 'Colibri::Order', touch: true, inverse_of: :payments
    belongs_to :source, polymorphic: true
    belongs_to :payment_method, class_name: 'Colibri::PaymentMethod'

    has_many :offsets, -> { where("source_type = 'Colibri::Payment' AND amount < 0 AND state = 'completed'") },
      class_name: "Colibri::Payment", foreign_key: :source_id
    has_many :log_entries, as: :source
    has_many :state_changes, as: :stateful
    has_many :capture_events, :class_name => 'Colibri::PaymentCaptureEvent'

    before_validation :validate_source
    before_create :set_unique_identifier
    before_save :update_uncaptured_amount

    after_save :create_payment_profile, if: :profiles_supported?

    # update the order totals, etc.
    after_save :update_order
    # invalidate previously entered payments
    after_create :invalidate_old_payments

    attr_accessor :source_attributes
    after_initialize :build_source

    scope :from_credit_card, -> { where(source_type: 'Colibri::CreditCard') }
    scope :with_state, ->(s) { where(state: s.to_s) }
    scope :completed, -> { with_state('completed') }
    scope :pending, -> { with_state('pending') }
    scope :failed, -> { with_state('failed') }
    scope :valid, -> { where.not(state: %w(failed invalid)) }

    after_rollback :persist_invalid

    validates :amount, numericality: true

    def persist_invalid
      return unless ['failed', 'invalid'].include?(state)
      state_will_change!
      save
    end

    # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
    state_machine initial: :checkout do
      # With card payments, happens before purchase or authorization happens
      event :started_processing do
        transition from: [:checkout, :pending, :completed, :processing], to: :processing
      end
      # When processing during checkout fails
      event :failure do
        transition from: [:pending, :processing], to: :failed
      end
      # With card payments this represents authorizing the payment
      event :pend do
        transition from: [:checkout, :processing], to: :pending
      end
      # With card payments this represents completing a purchase or capture transaction
      event :complete do
        transition from: [:processing, :pending, :checkout], to: :completed
      end
      event :void do
        transition from: [:pending, :completed, :checkout], to: :void
      end
      # when the card brand isnt supported
      event :invalidate do
        transition from: [:checkout], to: :invalid
      end

      after_transition do |payment, transition|
        payment.state_changes.create!(
          previous_state: transition.from,
          next_state:     transition.to,
          name:           'payment',
        )
      end
    end

    def currency
      order.currency
    end

    def money
      Colibri::Money.new(amount, { currency: currency })
    end
    alias display_amount money

    def amount=(amount)
      self[:amount] =
        case amount
        when String
          separator = I18n.t('number.currency.format.separator')
          number    = amount.delete("^0-9-#{separator}").tr(separator, '.')
          number.to_d if number.present?
        end || amount
    end

    def offsets_total
      offsets.pluck(:amount).sum
    end

    def credit_allowed
      amount - offsets_total.abs
    end

    def can_credit?
      credit_allowed > 0
    end

    # see https://github.com/colibri/colibri/issues/981
    def build_source
      return unless new_record?
      if source_attributes.present? && source.blank? && payment_method.try(:payment_source_class)
        self.source = payment_method.payment_source_class.new(source_attributes)
        self.source.payment_method_id = payment_method.id
        self.source.user_id = self.order.user_id if self.order
      end
    end

    def actions
      return [] unless payment_source and payment_source.respond_to? :actions
      payment_source.actions.select { |action| !payment_source.respond_to?("can_#{action}?") or payment_source.send("can_#{action}?", self) }
    end

    def payment_source
      res = source.is_a?(Payment) ? source.source : source
      res || payment_method
    end

    def is_avs_risky?
      return false if avs_response == "D"
      return false if avs_response.blank?
      return true
    end

    def is_cvv_risky?
      return false if cvv_response_code == "M"
      return false if cvv_response_code.nil?
      return false if cvv_response_message.present?
      return true
    end

    private

      def validate_source
        if source && !source.valid?
          source.errors.each do |field, error|
            field_name = I18n.t("activerecord.attributes.#{source.class.to_s.underscore}.#{field}")
            self.errors.add(Colibri.t(source.class.to_s.demodulize.underscore), "#{field_name} #{error}")
          end
        end
        return !errors.present?
      end

      def profiles_supported?
        payment_method.respond_to?(:payment_profiles_supported?) && payment_method.payment_profiles_supported?
      end

      def create_payment_profile
        return unless source.respond_to?(:has_payment_profile?) && !source.has_payment_profile?

        payment_method.create_profile(self)
      rescue ActiveMerchant::ConnectionError => e
        gateway_error e
      end

      def invalidate_old_payments
        order.payments.with_state('checkout').where("id != ?", self.id).each do |payment|
          payment.invalidate!
        end
      end

      def update_order
        if self.completed?
          order.updater.update_payment_total
        end

        if order.completed?
          order.updater.update_payment_state
          order.updater.update_shipments
          order.updater.update_shipment_state
        end

        if self.completed? || order.completed?
          order.persist_totals
        end
      end

      # Necessary because some payment gateways will refuse payments with
      # duplicate IDs. We *were* using the Order number, but that's set once and
      # is unchanging. What we need is a unique identifier on a per-payment basis,
      # and this is it. Related to #1998.
      # See https://github.com/colibri/colibri/issues/1998#issuecomment-12869105
      def set_unique_identifier
        begin
          self.identifier = generate_identifier
        end while self.class.exists?(identifier: self.identifier)
      end

      def generate_identifier
        Array.new(8){ IDENTIFIER_CHARS.sample }.join
      end

      def update_uncaptured_amount
        self.uncaptured_amount = amount - capture_events.sum(:amount)
      end
  end
end
