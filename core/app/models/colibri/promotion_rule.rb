# Base class for all promotion rules
module Colibri
  class PromotionRule < Colibri::Base
    belongs_to :promotion, class_name: 'Colibri::Promotion', inverse_of: :promotion_rules

    scope :of_type, ->(t) { where(type: t) }

    validate :promotion, presence: true
    validate :unique_per_promotion, on: :create

    def self.for(promotable)
      all.select { |rule| rule.applicable?(promotable) }
    end

    def applicable?(promotable)
      raise 'applicable? should be implemented in a sub-class of Colibri::PromotionRule'
    end

    def eligible?(promotable, options = {})
      raise 'eligible? should be implemented in a sub-class of Colibri::PromotionRule'
    end

    private
    def unique_per_promotion
      if Colibri::PromotionRule.exists?(promotion_id: promotion_id, type: self.class.name)
        errors[:base] << "Promotion already contains this rule type"
      end
    end

  end
end
