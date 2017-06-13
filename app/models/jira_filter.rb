require 'date'
require 'json'

class JiraFilter

	attr_accessor :filter_id

	@@base_uri = '/rest/api/2/filter/'
	@@query_fields = '&fields=id,key,project,summary,status,assignee,reporter,created,updated,statusCategory,fixVersions'

	# switch to ActiveModel::Model in Rails 4
	include ActiveModel::Model

	def initialize( filter_id )
		if filter_id.to_s.empty?
			@filter_id = "#{ENV['JIRA_DEFAULT_FILTER_ID']}"
		else
			@filter_id = filter_id
		end
	end

	def self.query_fields
		@@query_fields
	end

	def filter_uri
		@@base_uri + @filter_id.to_s
	end

	def load_issues( jira_client, include_sub_tasks=true )
		# Initialize
		issues_array = Array.new
		issueIdx = 0
		maxResults = 50

		# Pull filter by ID
		response = jira_client.get filter_uri
		jira_filter = JSON.parse( response.body )

		# Get the filter searchUrl
		searchUrl = jira_filter['searchUrl']

		# Get the first batch of issues
		response = jira_client.get( searchUrl + '&startAt=' + issueIdx.to_s +
			'&maxResults=' + maxResults.to_s +
			@@query_fields )

		filterSearch = JSON.parse (response.body)
		issues_array.concat( filterSearch['issues'] )

		# Get total issues in the filter
		totalIssues = filterSearch['total']

		until issueIdx >= totalIssues do
			issueIdx += maxResults

			# Get results via the searchUrl from JIRA
			response = jira_client.get( searchUrl + '&startAt=' + issueIdx.to_s +
				'&maxResults=' + maxResults.to_s +
				@@query_fields )

			filterSearch = JSON.parse (response.body)
			issues_array.concat( filterSearch['issues'] )
		end

		@issues = issues_array.map do |issue_elem|
			epic = JiraEpic.new( issue_elem )
			workItems = WorkItem.where( item_key: epic.item_key ).order( year: :desc, week: :desc )
			if include_sub_tasks
				epic.load_stories( jira_client )
				epic.load_people
			end
			epic.objective =  epic.getMRUObjective( workItems )
			epic.customer_facing = epic.getMRUCustomerFacing( workItems )
			epic.product = epic.getMRUProduct( workItems)
			epic.save
		end

	end
end
