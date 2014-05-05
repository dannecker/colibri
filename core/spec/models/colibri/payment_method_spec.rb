require 'spec_helper'

describe Colibri::PaymentMethod do
  describe "#available" do
    before do
      [nil, 'both', 'front_end', 'back_end'].each do |display_on|
        Colibri::Gateway::Test.create(
          :name => 'Display Both',
          :display_on => display_on,
          :active => true,
          :environment => 'test',
          :description => 'foofah'
        )
      end
    end

    it "should have 4 total methods" do
      Colibri::PaymentMethod.all.size.should == 4
    end

    it "should return all methods available to front-end/back-end when no parameter is passed" do
      Colibri::PaymentMethod.available.size.should == 2
    end

    it "should return all methods available to front-end/back-end when display_on = :both" do
      Colibri::PaymentMethod.available(:both).size.should == 2
    end

    it "should return all methods available to front-end when display_on = :front_end" do
      Colibri::PaymentMethod.available(:front_end).size.should == 2
    end

    it "should return all methods available to back-end when display_on = :back_end" do
      Colibri::PaymentMethod.available(:back_end).size.should == 2
    end
  end

  describe '#auto_capture?' do
    class TestGateway < Colibri::Gateway
      def provider_class
        Provider
      end
    end

    let(:gateway) { TestGateway.new }

    subject { gateway.auto_capture? }

    context 'when auto_capture is nil' do
      before(:each) do
        Colibri::Config.should_receive('[]').with(:auto_capture).and_return(auto_capture)
      end

      context 'and when Colibri::Config[:auto_capture] is false' do
        let(:auto_capture) { false }

        it 'should be false' do
          gateway.auto_capture.should be_nil
          subject.should be_false
        end
      end

      context 'and when Colibri::Config[:auto_capture] is true' do
        let(:auto_capture) { true }

        it 'should be true' do
          gateway.auto_capture.should be_nil
          subject.should be_true
        end
      end
    end

    context 'when auto_capture is not nil' do
      before(:each) do
        gateway.auto_capture = auto_capture
      end

      context 'and is true' do
        let(:auto_capture) { true }

        it 'should be true' do
          subject.should be_true
        end
      end

      context 'and is false' do
        let(:auto_capture) { false }

        it 'should be true' do
          subject.should be_false
        end
      end
    end
  end

end
