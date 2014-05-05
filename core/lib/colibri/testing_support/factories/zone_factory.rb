FactoryGirl.define do
  factory :global_zone, class: Colibri::Zone do
    name 'GlobalZone'
    description { generate(:random_string) }
    zone_members do |proxy|
      zone = proxy.instance_eval { @instance }
      Colibri::Country.all.map do |c|
        zone_member = Colibri::ZoneMember.create(zoneable: c, zone: zone)
      end
    end
  end

  factory :zone, class: Colibri::Zone do
    name { generate(:random_string) }
    description { generate(:random_string) }
  end
end
