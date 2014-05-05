require 'spec_helper'

describe Colibri::TaxonsController do
  it "should provide the current user to the searcher class" do
    taxon = create(:taxon, :permalink => "test")
    user = mock_model(Colibri.user_class, :last_incomplete_colibri_order => nil, :colibri_api_key => 'fake')
    controller.stub :colibri_current_user => user
    Colibri::Config.searcher_class.any_instance.should_receive(:current_user=).with(user)
    colibri_get :show, :id => taxon.permalink
    response.status.should == 200
  end
end
