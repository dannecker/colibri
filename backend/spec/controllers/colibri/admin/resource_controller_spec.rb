require 'spec_helper'

describe Colibri::Admin::ResourceController do
  stub_authorization!

  describe "POST#update_positions" do
    before do
      Colibri::Admin::ResourceController.any_instance.stub(:model_class).and_return(Colibri::Variant)
    end

    let(:variant) { create(:variant) }

    it "has 1 as initial position when created" do
      variant.position.should == 1
    end

    it "returns Ok on json" do
      variant2 = create(:variant)
      expect {
				colibri_post :update_positions, id: variant.id, positions: { variant.id => "2", variant2.id => "1" }, format: "js"
        variant.reload
      }.to change(variant, :position).from(1).to(2)
    end

    it "touches updated_at" do
      expect {
        colibri_post :update_positions, id: variant.id, positions: { variant.id => "2" }, format: "js"
        variant.reload
      }.to change(variant, :updated_at)
    end
  end
end
