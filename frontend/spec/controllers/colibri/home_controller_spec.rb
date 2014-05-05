require 'spec_helper'

describe Colibri::HomeController do
  it "provides current user to the searcher class" do
    user = mock_model(Colibri.user_class, :last_incomplete_colibri_order => nil, :colibri_api_key => 'fake')
    controller.stub :try_colibri_current_user => user
    Colibri::Config.searcher_class.any_instance.should_receive(:current_user=).with(user)
    colibri_get :index
    response.status.should == 200
  end

  context "layout" do
    it "renders default layout" do
      colibri_get :index
      response.should render_template(layout: 'colibri/layouts/colibri_application')
    end

    context "different layout specified in config" do
      before { Colibri::Config.layout = 'layouts/application' }

      it "renders specified layout" do
        colibri_get :index
        response.should render_template(layout: 'layouts/application')
      end
    end
  end
end
