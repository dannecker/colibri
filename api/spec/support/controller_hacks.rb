require 'active_support/all'
module ControllerHacks
  def api_get(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, "GET")
  end

  def api_post(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, "POST")
  end

  def api_put(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, "PUT")
  end

  def api_delete(action, params={}, session=nil, flash=nil)
    api_process(action, params, session, flash, "DELETE")
  end

  def api_process(action, params={}, session=nil, flash=nil, method="get")
    scoping = respond_to?(:resource_scoping) ? resource_scoping : {}
    process(action, method, params.merge(scoping).reverse_merge!(:use_route => :colibri, :format => :json), session, flash)
  end
end

RSpec.configure do |config|
  config.include ControllerHacks, :type => :controller
end
