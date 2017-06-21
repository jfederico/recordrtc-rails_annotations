class MessageController < ApplicationController
  include RailsLti2Provider::ControllerHelpers

  skip_before_action :verify_authenticity_token
  before_action :lti_authentication, except: [:youtube, :signed_content_item_request, :refresh_recordings]

  rescue_from RailsLti2Provider::LtiLaunch::Unauthorized do |ex|
    @error = 'Authentication failed with: ' + case ex.error
                                                when :invalid_signature
                                                  'The OAuth Signature was Invalid'
                                                when :invalid_nonce
                                                  'The nonce has already been used'
                                                when :request_to_old
                                                  'The request is to old'
                                                else
                                                  'Unknown Error'
                                              end
    @message = IMS::LTI::Models::Messages::Message.generate(request.request_parameters)
    @header = SimpleOAuth::Header.new(:post, request.url, @message.post_params, consumer_key: @message.oauth_consumer_key, consumer_secret: 'secret', callback: 'about:blank')
    render :basic_lti_launch_request, status: 200
  end

  def basic_lti_launch_request
    @disable_nav = true

    process_message
  end

  def recordrtc_launch_request
    process_message_recordrtc
  end

  def content_item_selection
    process_message
  end

  def signed_content_item_request
    key = 'key' # this should ideally be sent up via api call
    launch_url = params.delete('return_url')
    tool = RailsLti2Provider::Tool.where(uuid: 'key').last
    message = IMS::LTI::Models::Messages::Message.generate(request.request_parameters.merge(oauth_consumer_key: key))
    message.launch_url = launch_url
    @launch_params = { launch_url: message.launch_url, signed_params: message.signed_post_params(tool.shared_secret) }
    render 'message/signed_content_item_form'
  end

  def youtube
    redirect_to params[:youtube_url]
  end

  private
  def process_message
    @secret = "&#{RailsLti2Provider::Tool.find(@lti_launch.tool_id).shared_secret}"
    #TODO: should we create the lti_launch with all of the oauth params as well?
    @message = (@lti_launch && @lti_launch.message) || IMS::LTI::Models::Messages::Message.generate(request.request_parameters)
    @header = SimpleOAuth::Header.new(:post, request.url, @message.post_params, consumer_key: @message.oauth_consumer_key, consumer_secret: 'secret', callback: 'about:blank')
  end

  def process_message_recordrtc
    @secret = "&#{RailsLti2Provider::Tool.find(@lti_launch.tool_id).shared_secret}"
    #TODO: should we create the lti_launch with all of the oauth params as well?
    @message = (@lti_launch && @lti_launch.message) || IMS::LTI::Models::Messages::Message.generate(request.request_parameters)
    @header = SimpleOAuth::Header.new(:post, request.url, @message.post_params, consumer_key: @message.oauth_consumer_key, consumer_secret: 'secret', callback: 'about:blank')

    if @message.lti_version == 'LTI-2p0'
      session[:user_id] = @message.custom_person_sourcedid
      session[:full_name] = @message.custom_person_name_full
    elsif @message.lti_version == 'LTI-1p0'
      session[:user_id] = @message.lis_person_sourcedid
      session[:full_name] = @message.lis_person_name_full
    end

    redirect_to recordrtc_index_path
  end
end
