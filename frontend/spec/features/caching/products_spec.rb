require 'spec_helper'

describe 'products', :caching => true do
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, :taxonomy => taxonomy) }

  before do
    product2.update_column(:updated_at, 1.day.ago)
    # warm up the cache
    visit colibri.root_path
    assert_written_to_cache("views/USD/colibri/products/all--#{product.updated_at.utc.to_s(:number)}")
    assert_written_to_cache("views/USD/colibri/products/#{product.id}-#{product.updated_at.utc.to_s(:number)}")
    assert_written_to_cache("views/colibri/taxonomies/#{taxonomy.id}")
    assert_written_to_cache("views/taxons/#{taxon.updated_at.utc.to_i}")

    clear_cache_events
  end

  it "reads from cache upon a second viewing" do
    visit colibri.root_path
    expect(cache_writes.count).to eq(0)
  end

  it "busts the cache when a product is updated" do
    product.update_column(:updated_at, 1.day.from_now)
    visit colibri.root_path
    assert_written_to_cache("views/USD/colibri/products/all--#{product.updated_at.utc.to_s(:number)}")
    assert_written_to_cache("views/USD/colibri/products/#{product.id}-#{product.updated_at.utc.to_s(:number)}")
    expect(cache_writes.count).to eq(2)
  end

  it "busts the cache when all products are deleted" do
    product.destroy
    product2.destroy
    visit colibri.root_path
    assert_written_to_cache("views/USD/colibri/products/all--#{Date.today.to_s(:number)}-0")
    expect(cache_writes.count).to eq(1)
  end

  it "busts the cache when the newest product is deleted" do
    product.destroy
    visit colibri.root_path
    assert_written_to_cache("views/USD/colibri/products/all--#{product2.updated_at.utc.to_s(:number)}")
    expect(cache_writes.count).to eq(1)
  end

  it "busts the cache when an older product is deleted" do
    product2.destroy
    visit colibri.root_path
    assert_written_to_cache("views/USD/colibri/products/all--#{product.updated_at.utc.to_s(:number)}")
    expect(cache_writes.count).to eq(1)
  end
end
