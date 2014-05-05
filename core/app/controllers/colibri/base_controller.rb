require 'cancan'
require_dependency 'colibri/core/controller_helpers/strong_parameters'

class Colibri::BaseController < ApplicationController
  include Colibri::Core::ControllerHelpers::Auth
  include Colibri::Core::ControllerHelpers::RespondWith
  include Colibri::Core::ControllerHelpers::SSL
  include Colibri::Core::ControllerHelpers::Common
  include Colibri::Core::ControllerHelpers::Search
  include Colibri::Core::ControllerHelpers::Store
  include Colibri::Core::ControllerHelpers::StrongParameters

  respond_to :html
end

require 'colibri/i18n/initializer'
