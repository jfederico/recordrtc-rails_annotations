Gaffe.configure do |config|
  config.errors_controller = {
    %r[^/api/] => 'API::ErrorsController'
  }
end

Gaffe.enable!
