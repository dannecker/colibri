# Implementation class for Cancan gem.  Instead of overriding this class, consider adding new permissions
# using the special +register_ability+ method which allows extensions to add their own abilities.
#
# See http://github.com/ryanb/cancan for more details on cancan.
require 'cancan'
module Colibri
  class Ability
    include CanCan::Ability

    class_attribute :abilities
    self.abilities = Set.new

    # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
    # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
    # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
    # and therefore should be easy to test in isolation.
    def self.register_ability(ability)
      self.abilities.add(ability)
    end

    def self.remove_ability(ability)
      self.abilities.delete(ability)
    end

    def initialize(user)
      self.clear_aliased_actions

      # override cancan default aliasing (we don't want to differentiate between read and index)
      alias_action :delete, to: :destroy
      alias_action :edit, to: :update
      alias_action :new, to: :create
      alias_action :new_action, to: :create
      alias_action :show, to: :read

      user ||= Colibri.user_class.new

      if user.respond_to?(:has_colibri_role?) && user.has_colibri_role?('admin')
        can :manage, :all
      else
        can [:index, :read], Country
        can [:index, :read], OptionType
        can [:index, :read], OptionValue
        can :create, Order
        can :read, Order do |order, token|
          order.user == user || order.token && token == order.token
        end
        can :update, Order do |order, token|
          order.user == user || order.token && token == order.token
        end
        can [:create, :read], Address
        can :update, Address do |address|
          user.bill_address == address || user.ship_address == address
        end
        can [:index, :read], Product
        can [:index, :read], ProductProperty
        can [:index, :read], Property
        can :create, Colibri.user_class
        can [:read, :update, :destroy], Colibri.user_class, id: user.id
        can [:index, :read], State
        can [:index, :read], Taxon
        can [:index, :read], Taxonomy
        can [:index, :read], Variant
        can [:index, :read], Zone
      end

      # Include any abilities registered by extensions, etc.
      Ability.abilities.each do |clazz|
        ability = clazz.send(:new, user)
        @rules = rules + ability.send(:rules)
      end
    end
  end
end
