# Google does not accept query string parameters on callback URLs
# This overrised the OmniAuth gem method that gets the callback URL
# so that is does not include the querystring that would otherwise be appended

OmniAuth::Strategy.module_eval do
	def callback_url
		full_host + script_name + callback_path
	end
end
