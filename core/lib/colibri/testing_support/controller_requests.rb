# Use this module to easily test Colibri actions within Colibri components
# or inside your application to test routes for the mounted Colibri engine.
#
# Inside your spec_helper.rb, include this module inside the RSpec.configure
# block by doing this:
#
#   require 'colibri/testing_support/controller_requests'
#   RSpec.configure do |c|
#     c.include Colibri::TestingSupport::ControllerRequests, :type => :controller
#   end
#
# Then, in your controller tests, you can access colibri routes like this:
#
#   require 'spec_helper'
#
#   describe Colibri::ProductsController do
#     it "can see all the products" do
#       colibri_get :index
#     end
#   end
#
# Use colibri_get, colibri_post, colibri_put or colibri_delete to make requests
# to the Colibri engine, and use regular get, post, put or delete to make
# requests to your application.
#
module Colibri
  module TestingSupport
    module ControllerRequests
      def colibri_get(action, parameters = nil, session = nil, flash = nil)
        process_colibri_action(action, parameters, session, flash, "GET")
      end

      # Executes a request simulating POST HTTP method and set/volley the response
      def colibri_post(action, parameters = nil, session = nil, flash = nil)
        process_colibri_action(action, parameters, session, flash, "POST")
      end

      # Executes a request simulating PUT HTTP method and set/volley the response
      def colibri_put(action, parameters = nil, session = nil, flash = nil)
        process_colibri_action(action, parameters, session, flash, "PUT")
      end

      # Executes a request simulating DELETE HTTP method and set/volley the response
      def colibri_delete(action, parameters = nil, session = nil, flash = nil)
        process_colibri_action(action, parameters, session, flash, "DELETE")
      end

      def colibri_xhr_get(action, parameters = nil, session = nil, flash = nil)
        process_colibri_xhr_action(action, parameters, session, flash, :get)
      end

      def colibri_xhr_post(action, parameters = nil, session = nil, flash = nil)
        process_colibri_xhr_action(action, parameters, session, flash, :post)
      end

      def colibri_xhr_put(action, parameters = nil, session = nil, flash = nil)
        process_colibri_xhr_action(action, parameters, session, flash, :put)
      end

      def colibri_xhr_delete(action, parameters = nil, session = nil, flash = nil)
        process_colibri_xhr_action(action, parameters, session, flash, :delete)
      end

      private

      def process_colibri_action(action, parameters = nil, session = nil, flash = nil, method = "GET")
        parameters ||= {}
        process(action, method, parameters.merge!(:use_route => :colibri), session, flash)
      end

      def process_colibri_xhr_action(action, parameters = nil, session = nil, flash = nil, method = :get)
        parameters ||= {}
        parameters.reverse_merge!(:format => :json)
        parameters.merge!(:use_route => :colibri)
        xml_http_request(method, action, parameters, session, flash)
      end
    end
  end
end


