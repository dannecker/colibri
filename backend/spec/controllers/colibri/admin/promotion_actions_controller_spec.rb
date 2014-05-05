require 'spec_helper'

describe Colibri::Admin::PromotionActionsController do
  stub_authorization!

  let!(:promotion) { create(:promotion) }

  it "can create a promotion action of a valid type" do
    colibri_post :create, :promotion_id => promotion.id, :action_type => "Colibri::Promotion::Actions::CreateAdjustment"
    response.should be_redirect
    response.should redirect_to colibri.edit_admin_promotion_path(promotion)
    promotion.actions.count.should == 1
  end

  it "can not create a promotion action of an invalid type" do
    colibri_post :create, :promotion_id => promotion.id, :action_type => "Colibri::InvalidType"
    response.should be_redirect
    response.should redirect_to colibri.edit_admin_promotion_path(promotion)
    promotion.rules.count.should == 0
  end
end
