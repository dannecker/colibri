require 'spec_helper'

describe Colibri::Taxonomy do
  context "#destroy" do
    before do
       @taxonomy = create(:taxonomy)
       @root_taxon = @taxonomy.root
       @child_taxon = create(:taxon, :taxonomy_id => @taxonomy.id, :parent => @root_taxon)
    end

    it "should destroy all associated taxons" do
      @taxonomy.destroy
      expect{ Colibri::Taxon.find(@root_taxon.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect{ Colibri::Taxon.find(@child_taxon.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

