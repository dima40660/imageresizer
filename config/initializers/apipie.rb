Apipie.configure do |config|
  config.app_name                = "Imageresizer"
  config.default_version         = "1.0"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.validate                = false
  config.validate_value          = false
  config.translate               = false
  config.default_locale          = nil

  # set username and password for access api
  # config.authenticate = Proc.new do
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == "admin@example.com" && password == "password"
  #   end
  # end
end
