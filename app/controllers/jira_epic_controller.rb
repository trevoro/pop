class JiraEpicController < ApplicationController
	before_filter :get_jira_client

	def new
		@jira_epic_import = JiraEpicImport.new
	end

	def create
		@jira_epic_import = JiraEpicImport.new if @jira_epic_import.nil?

		filter_type = nil
		filter_id = nil

		if params.has_key?(:jira_epic_import)
			filter_type = params[:jira_epic_import][:filter_type]
			filter_id = params[:jira_epic_import][:filter_id]
			week = params[:jira_epic_import][:week]
			year = params[:jira_epic_import][:year]
		end

		@work_items = @jira_epic_import.import(@jira_client, filter_id, filter_type, week, year )

		redirect_to work_items_path( :week => week, :year => year )
	end

	def index
		redirect_to work_items_path
	end

end
