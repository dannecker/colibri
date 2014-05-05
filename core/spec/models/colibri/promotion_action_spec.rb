require 'spec_helper'

describe Colibri::PromotionAction do

  it "should force developer to implement 'perform' method" do
    expect { MyAction.new.perform }.to raise_error
  end

end

