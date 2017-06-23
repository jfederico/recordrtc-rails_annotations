class GuideController < ApplicationController
  require 'ims/lti'

  def xml_config
    icon_url = view_context.image_path('lti-icon.png')
    secure_icon_url = view_context.image_path('lti-icon.png').sub!('http://', 'https://')

    tc = IMS::LTI::Services::ToolConfig.new()
    tc.title = 'RecordRTC'
    tc.launch_url = recordrtc_launch_url
    tc.secure_launch_url = recordrtc_launch_url(:protocol => 'https')
    tc.icon = icon_url
    tc.secure_icon = secure_icon_url
    tc.description = 'This is an LTI tool for recording annotations.'

    if query_params = request.query_parameters
      platform = CanvasExtensions::PLATFORM
      tc.set_ext_param(platform, :selection_width, query_params[:selection_width])
      tc.set_ext_param(platform, :selection_height, query_params[:selection_height])
      tc.set_ext_param(platform, :privacy_level, 'public')
      tc.set_ext_param(platform, :text, 'Extension text')
      tc.set_ext_param(platform, :icon_url, view_context.image_path('lti-icon.png'))
      tc.set_ext_param(platform, :domain, request.host_with_port)

      query_params[:custom_params].each { |_, v| tc.set_custom_param(v[:name].to_sym, v[:value]) } if query_params[:custom_params]
      query_params[:placements].each { |k, _| create_placement(tc, k.to_sym) } if query_params[:placements]
    end

    render xml: tc.to_xml(:indent => 2)
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

    navigation_params[:icon_url] = view_context.image_path('lti-icon.png') + "?#{placement_key}"
    navigation_params[:canvas_icon_class] = "icon-lti"
    navigation_params[:text] = "#{placement_key} Text"

    tc.set_ext_param(CanvasExtensions::PLATFORM, placement_key, navigation_params)
  end
end
