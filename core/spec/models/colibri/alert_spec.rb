require 'spec_helper'
require 'webmock'

module Colibri
  describe Colibri::Alert do
    include WebMock::API

    before { WebMock.enable! }

    it "gets current alerts" do
      alerts_json = File.read(File.join(fixture_path, "alerts.json"))

      stub_request(:get, "alerts.colibriapp.com/alerts.json").
        with(:query => {
          version: Colibri.version,
          name: Colibri::Store.current.name,
          host: "localhost",
          rails_env: Rails.env,
          rails_version: Rails.version
        }).to_return(alerts_json)
      alerts = Colibri::Alert.current("localhost")
      alerts.first.should == {
        "created_at"=>"2013-07-13T11:47:58Z",
        "updated_at"=>"2013-07-13T11:47:58Z",
        "url"=>"",
        "id"=>24,
        "url_name"=>"Blog Post",
        "severity"=>"Release",
        "message"=>"Colibri 1.0 Released"
      }
    end
  end
end
