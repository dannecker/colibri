require 'spec_helper'

describe Colibri::AppConfiguration do

  let (:prefs) { Rails.application.config.colibri.preferences }

  it "should be available from the environment" do
    prefs.layout = "my/layout"
    prefs.layout.should eq "my/layout"
  end

  it "should be available as Colibri::Config for legacy access" do
    Colibri::Config.layout = "my/layout"
    Colibri::Config.layout.should eq "my/layout"
  end

  it "uses base searcher class by default" do
    prefs.searcher_class = nil
    prefs.searcher_class.should eq Colibri::Core::Search::Base
  end

end

