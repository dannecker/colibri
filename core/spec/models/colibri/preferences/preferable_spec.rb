require 'spec_helper'

describe Colibri::Preferences::Preferable do

  before :all do
    class A
      include Colibri::Preferences::Preferable
      attr_reader :id

      def initialize
        @id = rand(999)
      end

      def preferences
        @preferences ||= default_preferences
      end

      preference :color, :string, :default => 'green'
    end

    class B < A
      preference :flavor, :string
    end
  end

  before :each do
    @a = A.new
    @a.stub(:persisted? => true)
    @b = B.new
    @b.stub(:persisted? => true)

    # ensure we're persisting as that is the default
    #
    store = Colibri::Preferences::Store.instance
    store.persistence = true
  end

  describe "preference definitions" do
    it "parent should not see child definitions" do
      @a.has_preference?(:color).should be_true
      @a.has_preference?(:flavor).should_not be_true
    end

    it "child should have parent and own definitions" do
      @b.has_preference?(:color).should be_true
      @b.has_preference?(:flavor).should be_true
    end

    it "instances have defaults" do
      @a.preferred_color.should eq 'green'
      @b.preferred_color.should eq 'green'
      @b.preferred_flavor.should be_nil
    end

    it "can be asked if it has a preference definition" do
      @a.has_preference?(:color).should be_true
      @a.has_preference?(:bad).should be_false
    end

    it "can be asked and raises" do
      expect {
        @a.has_preference! :flavor
      }.to raise_error(NoMethodError, "flavor preference not defined")
    end

    it "has a type" do
      @a.preferred_color_type.should eq :string
      @a.preference_type(:color).should eq :string
    end

    it "has a default" do
      @a.preferred_color_default.should eq 'green'
      @a.preference_default(:color).should eq 'green'
    end

    it "raises if not defined" do
      expect {
        @a.get_preference :flavor
      }.to raise_error(NoMethodError, "flavor preference not defined")
    end

  end

  describe "preference access" do
    it "handles ghost methods for preferences" do
      @a.preferred_color = 'blue'
      @a.preferred_color.should eq 'blue'
    end

    it "parent and child instances have their own prefs" do
      @a.preferred_color = 'red'
      @b.preferred_color = 'blue'

      @a.preferred_color.should eq 'red'
      @b.preferred_color.should eq 'blue'
    end

    it "raises when preference not defined" do
      expect {
        @a.set_preference(:bad, :bone)
      }.to raise_exception(NoMethodError, "bad preference not defined")
    end

    it "builds a hash of preferences" do
      @b.preferred_flavor = :strawberry
      @b.preferences[:flavor].should eq 'strawberry'
      @b.preferences[:color].should eq 'green' #default from A
    end

    it "builds a hash of preference defaults" do
      @b.default_preferences.should eq({
        flavor: nil,
        color: 'green'
      })
    end

    context "converts integer preferences to integer values" do
      before do
        A.preference :is_integer, :integer
      end

      it "with strings" do
        @a.set_preference(:is_integer, '3')
        @a.preferences[:is_integer].should == 3

        @a.set_preference(:is_integer, '')
        @a.preferences[:is_integer].should == 0
      end

    end

    context "converts decimal preferences to BigDecimal values" do
      before do
        A.preference :if_decimal, :decimal
      end

      it "returns a BigDecimal" do
        @a.set_preference(:if_decimal, 3.3)
        @a.preferences[:if_decimal].class.should == BigDecimal
      end

      it "with strings" do
        @a.set_preference(:if_decimal, '3.3')
        @a.preferences[:if_decimal].should == 3.3

        @a.set_preference(:if_decimal, '')
        @a.preferences[:if_decimal].should == 0.0
      end
    end

    context "converts boolean preferences to boolean values" do
      before do
        A.preference :is_boolean, :boolean, :default => true
      end

      it "with strings" do
        @a.set_preference(:is_boolean, '0')
        @a.preferences[:is_boolean].should be_false
        @a.set_preference(:is_boolean, 'f')
        @a.preferences[:is_boolean].should be_false
        @a.set_preference(:is_boolean, 't')
        @a.preferences[:is_boolean].should be_true
      end

      it "with integers" do
        @a.set_preference(:is_boolean, 0)
        @a.preferences[:is_boolean].should be_false
        @a.set_preference(:is_boolean, 1)
        @a.preferences[:is_boolean].should be_true
      end

      it "with an empty string" do
        @a.set_preference(:is_boolean, '')
        @a.preferences[:is_boolean].should be_false
      end

      it "with an empty hash" do
        @a.set_preference(:is_boolean, [])
        @a.preferences[:is_boolean].should be_false
      end
    end

    context "converts any preferences to any values" do
      before do
        A.preference :product_ids, :any, :default => []
        A.preference :product_attributes, :any, :default => {}
      end

      it "with array" do
        @a.preferences[:product_ids].should == []
        @a.set_preference(:product_ids, [1, 2])
        @a.preferences[:product_ids].should == [1, 2]
      end

      it "with hash" do
        @a.preferences[:product_attributes].should == {}
        @a.set_preference(:product_attributes, {:id => 1, :name => 2})
        @a.preferences[:product_attributes].should == {:id => 1, :name => 2}
      end
    end

  end

  describe "persisted preferables" do
    before(:all) do
      class CreatePrefTest < ActiveRecord::Migration
        def self.up
          create_table :pref_tests do |t|
            t.string :col
            t.text :preferences
          end
        end

        def self.down
          drop_table :pref_tests
        end
      end

      @migration_verbosity = ActiveRecord::Migration.verbose
      ActiveRecord::Migration.verbose = false
      CreatePrefTest.migrate(:up)

      class PrefTest < Colibri::Base
        preference :pref_test_pref, :string, :default => 'abc'
        preference :pref_test_any, :any, :default => []
      end
    end

    after(:all) do
      CreatePrefTest.migrate(:down)
      ActiveRecord::Migration.verbose = @migration_verbosity
    end

    before(:each) do
      @pt = PrefTest.create
    end

    describe "pending preferences for new activerecord objects" do
      it "saves preferences after record is saved" do
        pr = PrefTest.new
        pr.set_preference(:pref_test_pref, 'XXX')
        pr.get_preference(:pref_test_pref).should == 'XXX'
        pr.save!
        pr.get_preference(:pref_test_pref).should == 'XXX'
      end

      it "saves preferences for serialized object" do
        pr = PrefTest.new
        pr.set_preference(:pref_test_any, [1, 2])
        pr.get_preference(:pref_test_any).should == [1, 2]
        pr.save!
        pr.get_preference(:pref_test_any).should == [1, 2]
      end
    end

    it "clear preferences" do
      @pt.set_preference(:pref_test_pref, 'xyz')
      @pt.preferred_pref_test_pref.should == 'xyz'
      @pt.clear_preferences
      @pt.preferred_pref_test_pref.should == 'abc'
    end

    it "clear preferences when record is deleted" do
      @pt.save!
      @pt.preferred_pref_test_pref = 'lmn'
      @pt.save!
      @pt.destroy
      @pt1 = PrefTest.new(:col => 'aaaa')
      @pt1.id = @pt.id
      @pt1.save!
      @pt1.get_preference(:pref_test_pref).should == 'abc'
    end
  end

end


