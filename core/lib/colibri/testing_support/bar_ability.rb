# Fake ability for testing administration
class BarAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Colibri::User.new
    if user.has_colibri_role? 'bar'
      # allow dispatch to :admin, :index, and :show on Colibri::Order
      can [:admin, :index, :show], Colibri::Order
      # allow dispatch to :index, :show, :create and :update shipments on the admin
      can [:admin, :manage], Colibri::Shipment
    end
  end
end
