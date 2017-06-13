Gaffe.configure do |config|
  config.errors_controller = {
    %r[^/api/] => 'API::ErrorsController',
    %r[^/] => 'ErrorsController'
  }
end

Gaffe.enable!
