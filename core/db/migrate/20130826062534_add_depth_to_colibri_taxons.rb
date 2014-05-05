class AddDepthToColibriTaxons < ActiveRecord::Migration
  def up
    if !Colibri::Taxon.column_names.include?('depth')
      add_column :colibri_taxons, :depth, :integer

      say_with_time 'Update depth on all taxons' do
        Colibri::Taxon.reset_column_information
        Colibri::Taxon.all.each { |t| t.save }
      end
    end
  end

  def down
    remove_column :colibri_taxons, :depth
  end
end
