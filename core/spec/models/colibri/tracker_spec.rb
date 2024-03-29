require 'spec_helper'

describe Colibri::Tracker do
  describe "current" do
    before(:each) { @tracker = create(:tracker) }

    it "returns the first active tracker for the environment" do
      Colibri::Tracker.current.should == @tracker
    end

    it "does not return a tracker with a blank analytics_id" do
      @tracker.update_attribute(:analytics_id, '')
      Colibri::Tracker.current.should be_nil
    end

    it "does not return an inactive tracker" do
      @tracker.update_attribute(:active, false)
      Colibri::Tracker.current.should be_nil
    end
  end
end
