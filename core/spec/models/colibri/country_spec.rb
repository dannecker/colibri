require 'spec_helper'

describe Colibri::Country do
  it "can find all countries group by states required" do
    country_states_required= Colibri::Country.create({:name => "Canada", :iso_name => "CAN", :states_required => true})
    country_states_not_required= Colibri::Country.create({:name => "France", :iso_name => "FR", :states_required => false})
    states_required = Colibri::Country.states_required_by_country_id
    states_required[country_states_required.id.to_s].should be_true
    states_required[country_states_not_required.id.to_s].should be_false
  end

  it "returns that the states are required for an invalid country" do
    Colibri::Country.states_required_by_country_id['i do not exit'].should be_true
  end
end
