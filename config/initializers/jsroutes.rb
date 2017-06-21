JsRoutes.setup do |config|
  config.exclude = [/^.*$/]
  config.include = [/^api\/recordings(?!\/)$/]
end
