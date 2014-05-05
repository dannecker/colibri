module Colibri
  class PromotionActionLineItem < Colibri::Base
    belongs_to :promotion_action, class_name: 'Colibri::Promotion::Actions::CreateLineItems'
    belongs_to :variant, class_name: 'Colibri::Variant'
  end
end
