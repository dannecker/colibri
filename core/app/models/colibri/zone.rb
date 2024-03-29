module Colibri
  class Zone < Colibri::Base
    has_many :zone_members, dependent: :destroy, class_name: "Colibri::ZoneMember"
    has_many :tax_rates, dependent: :destroy
    has_and_belongs_to_many :shipping_methods, :join_table => 'colibri_shipping_methods_zones'

    validates :name, presence: true, uniqueness: true
    after_save :remove_defunct_members
    after_save :remove_previous_default

    alias :members :zone_members
    accepts_nested_attributes_for :zone_members, allow_destroy: true, reject_if: proc { |a| a['zoneable_id'].blank? }

    def self.default_tax
      where(default_tax: true).first
    end
  
    # Returns the matching zone with the highest priority zone type (State, Country, Zone.)
    # Returns nil in the case of no matches.
    def self.match(address)
      return unless address and matches = self.includes(:zone_members).
        order('colibri_zones.zone_members_count', 'colibri_zones.created_at').
        where("(colibri_zone_members.zoneable_type = 'Colibri::Country' AND colibri_zone_members.zoneable_id = ?) OR (colibri_zone_members.zoneable_type = 'Colibri::State' AND colibri_zone_members.zoneable_id = ?)", address.country_id, address.state_id).
        references(:zones)

      ['state', 'country'].each do |zone_kind|
        if match = matches.detect { |zone| zone_kind == zone.kind }
          return match
        end
      end
      matches.first
    end

    def kind
      if members.any? && !members.any? { |member| member.try(:zoneable_type).nil? }
        members.last.zoneable_type.demodulize.underscore
      end
    end

    def kind=(value)
      # do nothing - just here to satisfy the form
    end

    def include?(address)
      return false unless address

      members.any? do |zone_member|
        case zone_member.zoneable_type
        when 'Colibri::Country'
          zone_member.zoneable_id == address.country_id
        when 'Colibri::State'
          zone_member.zoneable_id == address.state_id
        else
          false
        end
      end
    end

    # convenience method for returning the countries contained within a zone
    def country_list
      @countries ||= case kind
                     when 'country' then zoneables
                     when 'state' then zoneables.collect(&:country)
                     else nil
                     end.flatten.compact.uniq
    end

    def <=>(other)
      name <=> other.name
    end

    # All zoneables belonging to the zone members.  Will be a collection of either
    # countries or states depending on the zone type.
    def zoneables
      members.collect(&:zoneable)
    end

    def country_ids
      if kind == 'country'
        members.collect(&:zoneable_id)
      else
        []
      end
    end

    def state_ids
      if kind == 'state'
        members.collect(&:zoneable_id)
      else
        []
      end
    end

    def country_ids=(ids)
      zone_members.destroy_all
      ids.reject{ |id| id.blank? }.map do |id|
        member = ZoneMember.new
        member.zoneable_type = 'Colibri::Country'
        member.zoneable_id = id
        members << member
      end
    end

    def state_ids=(ids)
      zone_members.destroy_all
      ids.reject{ |id| id.blank? }.map do |id|
        member = ZoneMember.new
        member.zoneable_type = 'Colibri::State'
        member.zoneable_id = id
        members << member
      end
    end

    # Indicates whether the specified zone falls entirely within the zone performing
    # the check.
    def contains?(target)
      return false if kind == 'state' && target.kind == 'country'
      return false if zone_members.empty? || target.zone_members.empty?

      if kind == target.kind
        return false if target.zoneables.any? { |target_zoneable| zoneables.exclude?(target_zoneable) }
      else
        return false if target.zoneables.any? { |target_state| zoneables.exclude?(target_state.country) }
      end
      true
    end

    private

      def remove_defunct_members
        if zone_members.any?
          zone_members.where('zoneable_id IS NULL OR zoneable_type != ?', "Colibri::#{kind.classify}").destroy_all
        end
      end

      def remove_previous_default
        Colibri::Zone.where('id != ?', self.id).update_all(default_tax: false) if default_tax
      end
  end
end
