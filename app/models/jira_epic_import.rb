require 'date'
require 'json'
require "net/http"
require "uri"

class JiraEpicImport
	# switch to ActiveModel::Model in Rails 4
	include ActiveModel::Model

	attr_accessor :filter_id
	attr_accessor :filter_type
	attr_accessor :week
	attr_accessor :year

	def self.importJIRAEpics
		puts "[ " + Time.now.to_formatted_s(:db) + " ]: Item import started"

		# Set up options
		options = {
			:context_path => "",
			:site => "#{ENV['JIRA_URL']}",
			:private_key_file => "#{ENV['JIRA_PRIVATE_KEY_FILE']}",
			:consumer_key => "#{ENV['JIRA_CONSUMER_KEY']}"
		}

		# Create client
		jira_client = JIRA::Client.new(options)
		jira_client.set_access_token( "#{ENV['JIRA_OAUTH_TOKEN']}", "#{ENV['JIRA_OAUTH_KEY']}" )

		# Create and run import job
		jira_epic_import = JiraEpicImport.new
		results = jira_epic_import.import( jira_client )

		result_count = ( !results.nil? && results.kind_of?(Array)) ? results.length : 0

		puts "[ " + Time.now.to_formatted_s(:db) + " ]: Imported " + result_count.to_s + " issues"

	end

	def initialize(attributes = {})
		unless attributes.nil?
			attributes.each { |name, value| send("#{name}=", value) }
		end
	end

	def import( jira_client, jira_item_id, filter_type = "filter", week = Date.today.cweek, year = Date.today.year)
		if filter_type == "epic"
			JiraEpic.load_issue( jira_client, jira_item_id, week, year)
		else
			jira_filter = JiraFilter.new( jira_item_id )
			jira_filter.load_issues( jira_client )
		end
	end

end
