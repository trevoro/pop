class WebhooksController < ApplicationController

	protect_from_forgery with: :null_session

	def jira_issues

		Rails.logger.info(params.to_json)

		respond_to do |format|
			format.html
		end
	end

end
