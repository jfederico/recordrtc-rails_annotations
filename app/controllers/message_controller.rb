class MessageController < ApplicationController
  require 'ims/lti'
  include RailsLti2Provider::ControllerHelpers

  skip_before_action :verify_authenticity_token
  before_action :lti_authentication, except: [:xml_config, :youtube, :signed_content_item_request]

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
    @header = SimpleOAuth::Header.new(:post, request.url, @message.post_params, consumer_key: @message.oauth_consumer_key, consumer_secret: ENV['LTI_SECRET'], callback: 'about:blank')

    render :launch_request, status: 200
  end

  def xml_config
    domain = 'http://' + request.host_with_port
    secure_domain = 'https://' + request.host_with_port
    icon_url = domain + view_context.image_path('lti-icon.png')
    secure_icon_url = secure_domain + view_context.image_path('lti-icon.png')

    tc = IMS::LTI::Services::ToolConfig.new()
    tc.title = 'RecordRTC'
    tc.description = 'An LTI tool for recording annotations'
    tc.launch_url = recordrtc_launch_url
    tc.secure_launch_url = recordrtc_launch_url(:protocol => 'https')
    tc.icon = icon_url
    tc.secure_icon = secure_icon_url
    tc.vendor_code = 'blindside_networks'
    tc.vendor_name = 'Blindside Networks'
    tc.vendor_description = 'Blindside Networks is a company dedicated to helping universities, colleges and commercial companies deliver a high-quality learning experience to remote students. We do this by providing commercial support and hosting for BigBlueButton, an open source web conferencing system for distance education.'
    tc.vendor_url = 'http://www.blindsidenetworks.com/'
    tc.vendor_contact_name = 'Fred Dixon'
    tc.vendor_contact_email = 'ffdixon@blindsidenetworks.com'
    tc.cartridge_bundle = 'RECORDRTC_LTI1&2_Bundle'
    tc.cartridge_icon = 'RECORDRTC_LTI1&2_Icon'

    if query_params = request.query_parameters
      platform = CanvasExtensions::PLATFORM
      tc.set_ext_param(platform, :selection_width, query_params[:selection_width])
      tc.set_ext_param(platform, :selection_height, query_params[:selection_height])
      tc.set_ext_param(platform, :privacy_level, 'public')
      tc.set_ext_param(platform, :text, 'Extension text')
      tc.set_ext_param(platform, :icon_url, icon_url)
      tc.set_ext_param(platform, :domain, request.host_with_port)
      create_placement(tc, :course_navigation)

      query_params[:custom_params].each { |_, v| tc.set_custom_param(v[:name].to_sym, v[:value]) } if query_params[:custom_params]
      query_params[:placements].each { |k, _| create_placement(tc, k.to_sym) } if query_params[:placements]
    end

    render xml: tc.to_xml(:indent => 2)
  end

  def launch_request
    @disable_nav = true

    process_message
  end

  def content_item_selection
    process_message
  end

  def signed_content_item_request
    key = ENV['LTI_KEY'] # this should ideally be sent up via api call
    launch_url = params.delete('return_url')
    tool = RailsLti2Provider::Tool.where(uuid: ENV['LTI_KEY']).last
    message = IMS::LTI::Models::Messages::Message.generate(request.request_parameters.merge(oauth_consumer_key: key))
    message.launch_url = launch_url
    @launch_params = { launch_url: message.launch_url, signed_params: message.signed_post_params(tool.shared_secret) }
    render 'message/signed_content_item_form'
  end

  def youtube
    redirect_to params[:youtube_url]
  end

  private
  def create_placement(tc, placement_key)
    message_type = request.query_parameters["#{placement_key}_message_type"] || :basic_lti_request
    navigation_params = case message_type
                        when 'content_item_selection'
                          {url: content_item_launch_url, message_type: 'ContentItemSelection'}
                        when 'content_item_selection_request'
                          {url: content_item_request_launch_url, message_type: 'ContentItemSelectionRequest'}
                        else
                          {url: recordrtc_launch_url}
                        end
    navigation_params[:text] = 'RecordRTC'

    tc.set_ext_param(CanvasExtensions::PLATFORM, placement_key, navigation_params)
  end

  def process_message
    @secret = "&#{RailsLti2Provider::Tool.find(@lti_launch.tool_id).shared_secret}"
    #TODO: should we create the lti_launch with all of the oauth params as well?
    @message = (@lti_launch && @lti_launch.message) || IMS::LTI::Models::Messages::Message.generate(request.request_parameters)
    @header = SimpleOAuth::Header.new(:post, request.url, @message.post_params, consumer_key: @message.oauth_consumer_key, consumer_secret: ENV['LTI_SECRET'], callback: 'about:blank')

    if @message.lti_version == 'LTI-2p0'
      session[:user_id] = @message.custom_person_sourcedid || @message.user_id
      session[:full_name] = @message.custom_person_name_full || 'Student View'
    elsif @message.lti_version == 'LTI-1p0'
      session[:user_id] = @message.lis_person_sourcedid || @message.user_id
      session[:full_name] = @message.lis_person_name_full || 'Student View'
    end

    redirect_to record_index_path
  end
end
