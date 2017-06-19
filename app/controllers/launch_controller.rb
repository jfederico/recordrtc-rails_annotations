class LaunchController < ApplicationController
  include RailsLti2Provider::ControllerHelpers
  
  skip_before_action :verify_authenticity_token
  before_action :lti_authentication
  after_action :disable_xframe_header

  def default
  end
end
