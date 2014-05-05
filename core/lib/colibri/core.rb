require 'rails/all'
require 'active_merchant'
require 'acts_as_list'
require 'awesome_nested_set'
require 'cancan'
require 'kaminari'
require 'mail'
require 'monetize'
require 'paperclip'
require 'paranoia'
require 'ransack'
require 'state_machine'
require 'friendly_id'

module Colibri

  mattr_accessor :user_class

  def self.user_class
    if @@user_class.is_a?(Class)
      raise "Colibri.user_class MUST be a String or Symbol object, not a Class object."
    elsif @@user_class.is_a?(String) || @@user_class.is_a?(Symbol)
      @@user_class.to_s.constantize
    end
  end

  # Used to configure Colibri.
  #
  # Example:
  #
  #   Colibri.config do |config|
  #     config.track_inventory_levels = false
  #   end
  #
  # This method is defined within the core gem on purpose.
  # Some people may only wish to use the Core part of Colibri.
  def self.config(&block)
    yield(Colibri::Config)
  end

  module Core
    autoload :ProductFilters, "colibri/core/product_filters"

    class GatewayError < RuntimeError; end
    class DestroyWithOrdersError < StandardError; end
  end
end

require 'colibri/core/version'

require 'colibri/core/environment_extension'
require 'colibri/core/environment/calculators'
require 'colibri/core/environment'
require 'colibri/promo/environment'
require 'colibri/migrations'
require 'colibri/core/engine'

require 'colibri/i18n'
require 'colibri/money'

require 'colibri/permitted_attributes'
require 'colibri/core/user_address'
require 'colibri/core/user_payment_source'
require 'colibri/core/delegate_belongs_to'
require 'colibri/core/permalinks'
require 'colibri/core/token_resource'
require 'colibri/core/calculated_adjustments'
require 'colibri/core/product_duplicator'
require 'colibri/core/controller_helpers'
require 'colibri/core/controller_helpers/search'
require 'colibri/core/controller_helpers/ssl'
require 'colibri/core/controller_helpers/store'
require 'colibri/core/controller_helpers/strong_parameters'

require 'colibri/core/importer'

# Hack waiting on https://github.com/pluginaweek/state_machine/pull/275
module StateMachine
  module Integrations
    module ActiveModel
      public :around_validation
    end
  end
end
