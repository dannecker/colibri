require 'spec_helper'

# This test tests the functionality within
# colibri/core/controller_helpers/respond_with.rb
# Rather than duck-punching the existing controllers, let's define a custom one:
class Colibri::CustomController < Colibri::BaseController
  def index
    respond_with(Colibri::Address.new) do |format|
      format.html { render :text => "neutral" }
    end
  end

  def create
    # Just need a model with validations
    # Address is good enough, so let's go with that
    address = Colibri::Address.new(params[:address])
    respond_with(address)
  end
end

describe Colibri::CustomController do
  after do
    Colibri::CustomController.clear_overrides!
  end

  context "extension testing" do
    context "index" do
      context "specify symbol for handler instead of Proc" do
        before do
          Colibri::CustomController.class_eval do
            respond_override({:index => {:html => {:success => :success_method}}})

            private

            def success_method
              render :text => 'success!!!'
            end
          end
        end
        describe "GET" do
          it "has value success" do
            colibri_get :index
            response.should be_success
            assert (response.body =~ /success!!!/)
          end
        end
      end

      context "render" do
        before do
          Colibri::CustomController.instance_eval do
            respond_override({:index => {:html => {:success => lambda { render(:text => 'success!!!') }}}})
            respond_override({:index => {:html => {:failure => lambda { render(:text => 'failure!!!') }}}})
          end
        end
        describe "GET" do
          it "has value success" do
            colibri_get :index
            response.should be_success
            assert (response.body =~ /success!!!/)
          end
        end
      end

      context "redirect" do
        before do
          Colibri::CustomController.instance_eval do
            respond_override({:index => {:html => {:success => lambda { redirect_to('/cart') }}}})
            respond_override({:index => {:html => {:failure => lambda { render(:text => 'failure!!!') }}}})
          end
        end
        describe "GET" do
          it "has value success" do
            colibri_get :index
            response.should be_redirect
          end
        end
      end

      context "validation error" do
        before do
          Colibri::CustomController.instance_eval do
            respond_to :html
            respond_override({:create => {:html => {:success => lambda { render(:text => 'success!!!') }}}})
            respond_override({:create => {:html => {:failure => lambda { render(:text => 'failure!!!') }}}})
          end
        end

        describe "POST" do
          it "has value success" do
            colibri_post :create
            response.should be_success
            assert (response.body =~ /success!/)
          end
        end
      end

      context 'A different controllers respond_override. Regression test for #1301' do
        before do
          Colibri::CheckoutController.instance_eval do
            respond_override({:index => {:html => {:success => lambda { render(:text => 'success!!!') }}}})
          end
        end
        describe "POST" do
          it "should not effect the wrong controller" do
            colibri_get :index
            assert (response.body =~ /neutral/)
          end
        end
      end

    end
  end

end
