class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper_method :current_user

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id] && User.exists?(session[:user_id])
	end

	rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
		redirect_to new_jira_session_url
	end

	private

	def get_jira_client

		# add any extra configuration options for your instance of JIRA,
		# e.g. :use_ssl, :ssl_verify_mode, :context_path, :site
		options = {
			:context_path => "",
			:site => "#{ENV['JIRA_URL']}",
			:private_key_file => "#{ENV['JIRA_PRIVATE_KEY_FILE']}",
			:consumer_key => "#{ENV['JIRA_CONSUMER_KEY']}"
		}

		@jira_client = JIRA::Client.new(options)

		# Add AccessToken if authorised previously.
		if session[:jira_auth]
			@jira_client.set_access_token(
				session[:jira_auth][:access_token],
				session[:jira_auth][:access_key]
			)
		end
	end

end
