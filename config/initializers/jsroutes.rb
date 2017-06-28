JsRoutes.setup do |config|
  config.default_url_options = {'protocol': 'https'}
  config.include = [/^api_recordings$/]
end
