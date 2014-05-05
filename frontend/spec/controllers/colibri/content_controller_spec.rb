require 'spec_helper'
describe Colibri::ContentController do
  it "should not display a local file" do
    colibri_get :show, :path => "../../Gemfile"
    response.response_code.should == 404
  end

  it "should display CVV page" do
    colibri_get :cvv
    response.response_code.should == 200
  end
end
