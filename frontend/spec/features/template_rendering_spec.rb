require 'spec_helper'

describe "Template rendering" do

  after do
    Capybara.ignore_hidden_elements = true
  end

  before do
    Capybara.ignore_hidden_elements = false
  end

  it 'layout should have canonical tag referencing site url' do
    Colibri::Store.create!(code: 'colibri', name: 'My Colibri Store', url: 'colibristore.example.com', mail_from_address: 'test@example.com')

    visit colibri.root_path
    find('link[rel=canonical]')[:href].should eql('http://colibristore.example.com/')
  end
end
