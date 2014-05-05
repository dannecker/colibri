require 'spec_helper'
require 'webmock'

module Colibri
  describe Colibri::Alert do
    include WebMock::API

    before { WebMock.enable! }

    it "gets current alerts" do
      alerts_json = File.read(File.join(fixture_path, "alerts.json"))

      stub_request(:get, "alerts.colibricommerce.com/alerts.json").
        with(:query => {
          version: Colibri.version,
          name: Colibri::Store.current.name,
          host: "localhost",
          rails_env: Rails.env,
          rails_version: Rails.version
        }).to_return(alerts_json)
      alerts = Colibri::Alert.current("localhost")
      alerts.first.should == {
        "created_at"=>"2012-07-13T11:47:58Z",
        "updated_at"=>"2012-07-13T11:47:58Z",
        "url"=>"http://colibricommerce.com/blog/2012/07/12/colibri-1-0-6-released/",
        "id"=>24,
        "url_name"=>"Blog Post",
        "severity"=>"Release",
        "message"=>"Colibri 1.0.6 Released"
      }
    end
  end
end
