require 'spec_helper'

# In this file, we want to test that the controller helpers function correctly
# So we need to use one of the controllers inside Colibri.
# ProductsController is good.
describe Colibri::ProductsController do

  before do
    I18n.stub(:available_locales => [:en, :de])
    Colibri::Frontend::Config[:locale] = :de
  end

  after do
    Colibri::Frontend::Config[:locale] = :en
    I18n.locale = :en
  end

  # Regression test for #1184
  it "sets the default locale based off Colibri::Frontend::Config[:locale]" do
    I18n.locale.should == :en
    colibri_get :index
    I18n.locale.should == :de
  end
end
