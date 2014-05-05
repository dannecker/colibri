require 'spec_helper'

module Colibri
  describe LegacyUser do
    let(:user) { LegacyUser.new }

    it "can generate an API key" do
      user.should_receive(:save!)
      user.generate_colibri_api_key!
      user.colibri_api_key.should_not be_blank
    end

    it "can clear an API key" do
      user.should_receive(:save!)
      user.clear_colibri_api_key!
      user.colibri_api_key.should be_blank
    end
  end
end
