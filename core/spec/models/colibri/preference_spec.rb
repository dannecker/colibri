require 'spec_helper'

describe Colibri::Preference do

  it "should require a key" do
    @preference = Colibri::Preference.new
    @preference.key = :test
    @preference.value = true
    @preference.should be_valid
  end

  describe "type coversion for values" do
    def round_trip_preference(key, value)
      p = Colibri::Preference.new
      p.value = value
      p.key = key
      p.save

      Colibri::Preference.find_by_key(key)
    end

    it ":boolean" do
      value = true
      key = "boolean_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it "false :boolean" do
      value = false
      key = "boolean_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it ":integer" do
      value = 10
      key = "integer_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it ":decimal" do
      value = 1.5
      key = "decimal_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it ":string" do
      value = "This is a string"
      key = "string_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it ":text" do
      value = "This is a string stored as text"
      key = "text_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it ":password" do
      value = "This is a password"
      key = "password_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

    it ":any" do
      value = [1, 2]
      key = "any_key"
      pref = round_trip_preference(key, value)
      pref.value.should eq value
    end

  end

end
