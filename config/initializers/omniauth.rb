OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "#{ENV['GOOGLE_APPS_ID']}", "#{ENV['GOOGLE_APPS_SECRET']}"
end
