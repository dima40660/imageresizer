if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter 'lib'
    add_filter '/app/controllers/users'
    add_filter '/app/docs'
    add_filter 'app/helpers/session_helper.rb'
    add_filter 'app/controllers/api/v3/finversia_controller.rb'
    add_filter 'app/controllers/concerns/get_client_token_id.rb'
    add_filter 'app/controllers/base_controller.rb'
    add_filter 'app/controllers/api/v3/educations_controller.rb'
    add_filter 'app/helpers/locale_helper.rb'
    add_filter 'app/models/facebook.rb'
    add_filter do |source_file|
      source_file.lines.count < 5
    end
  end
  puts "required simplecov"
end