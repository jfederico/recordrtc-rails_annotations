class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from RailsLti2Provider::LtiLaunch::Unauthorized do |ex|
    render :text => 'Unauthorized', :status => 401
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActionController::InvalidAuthenticityToken, with: :render_422
  rescue_from ActionController::InvalidCrossOriginRequest, with: :render_422
  rescue_from StandardError, with: :render_500

  def render_404
    render template: '404', status: 404
  end

  def render_422
    render template: '422', status: 422
  end

  def render_500
    render template: '500', status: 500
  end
end
