require 'spec_helper'

describe "Product scopes" do
  let!(:product) { create(:product) }

  context "A product assigned to parent and child taxons" do
    before do
      @taxonomy = create(:taxonomy)
      @root_taxon = @taxonomy.root

      @parent_taxon = create(:taxon, :name => 'Parent', :taxonomy_id => @taxonomy.id, :parent => @root_taxon)
      @child_taxon = create(:taxon, :name =>'Child 1', :taxonomy_id => @taxonomy.id, :parent => @parent_taxon)
      @parent_taxon.reload # Need to reload for descendents to show up

      product.taxons << @parent_taxon
      product.taxons << @child_taxon
    end

    it "calling Product.in_taxon returns products in child taxons" do
      product.taxons -= [@child_taxon]
      product.taxons.count.should == 1

      Colibri::Product.in_taxon(@parent_taxon).should include(product)
    end

    it "calling Product.in_taxon should not return duplicate records" do
      Colibri::Product.in_taxon(@parent_taxon).to_a.count.should == 1
    end

    it "orders products based on their ordering within the classification" do
      product_2 = create(:product)
      product_2.taxons << @parent_taxon

      product_root_classification = Colibri::Classification.find_by(:taxon => @parent_taxon, :product => product)
      product_root_classification.update_column(:position, 1)

      product_2_root_classification = Colibri::Classification.find_by(:taxon => @parent_taxon, :product => product_2)
      product_2_root_classification.update_column(:position, 2)

      Colibri::Product.in_taxon(@parent_taxon).should == [product, product_2]
      product_2_root_classification.insert_at(1)
      Colibri::Product.in_taxon(@parent_taxon).should == [product_2, product]
    end
  end

  context "property scopes" do
    let(:name) { "A proper tee" }
    let(:value) { "A proper value"}
    let!(:property) { create(:property, name: name)}

    before do
      product.properties << property
      product.product_properties.find_by(property: property).update_column(:value, value)
    end

    context "with_property" do
      let(:with_property) { Colibri::Product.method(:with_property) }
      it "finds by a property's name" do
        expect(with_property.(name).count).to eq(1)
      end

      it "doesn't find any properties with an unknown name" do
        expect(with_property.("fake").count).to eq(0)
      end

      it "finds by a property" do
        expect(with_property.(property).count).to eq(1)
      end

      it "finds by an id" do
        expect(with_property.(property.id).count).to eq(1)
      end

      it "cannot find a property with an unknown id" do
        expect(with_property.(0).count).to eq(0)
      end
    end

    context "with_property_value" do
      let(:with_property_value) { Colibri::Product.method(:with_property_value) }
      it "finds by a property's name" do
        expect(with_property_value.(name, value).count).to eq(1)
      end

      it "cannot find by an unknown property's name" do
        expect(with_property_value.("fake", value).count).to eq(0)
      end

      it "cannot find with a name by an incorrect value" do
        expect(with_property_value.(name, "fake").count).to eq(0)
      end

      it "finds by a property" do
        expect(with_property_value.(property, value).count).to eq(1)
      end

      it "cannot find with a property by an incorrect value" do
        expect(with_property_value.(property, "fake").count).to eq(0)
      end

      it "finds by an id with a value" do
        expect(with_property_value.(property.id, value).count).to eq(1)
      end

      it "cannot find with an invalid id" do
        expect(with_property_value.(0, value).count).to eq(0)
      end

      it "cannot find with an invalid value" do
        expect(with_property_value.(property.id, "fake").count).to eq(0)
      end
    end
  end

  context '#add_simple_scopes' do
    let(:simple_scopes) { [:ascend_by_updated_at, :descend_by_name] }

    before do
      Colibri::Product.add_simple_scopes(simple_scopes)
    end

    context 'define scope' do
      context 'ascend_by_updated_at' do
        context 'on class' do
          it { Colibri::Product.ascend_by_updated_at.to_sql.should eq Colibri::Product.order("#{Colibri::Product.quoted_table_name}.updated_at ASC").to_sql }
        end

        context 'on ActiveRecord::Relation' do
          it { Colibri::Product.limit(2).ascend_by_updated_at.to_sql.should eq Colibri::Product.limit(2).order("#{Colibri::Product.quoted_table_name}.updated_at ASC").to_sql }
          it { Colibri::Product.limit(2).ascend_by_updated_at.to_sql.should eq Colibri::Product.ascend_by_updated_at.limit(2).to_sql }
        end
      end

      context 'descend_by_name' do
        context 'on class' do
          it { Colibri::Product.descend_by_name.to_sql.should eq Colibri::Product.order("#{Colibri::Product.quoted_table_name}.name DESC").to_sql }
        end

        context 'on ActiveRecord::Relation' do
          it { Colibri::Product.limit(2).descend_by_name.to_sql.should eq Colibri::Product.limit(2).order("#{Colibri::Product.quoted_table_name}.name DESC").to_sql }
          it { Colibri::Product.limit(2).descend_by_name.to_sql.should eq Colibri::Product.descend_by_name.limit(2).to_sql }
        end
      end
    end
  end
end
