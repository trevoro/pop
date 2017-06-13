require "net/http"
require "uri"

class JiraEpic

	attr_reader :item_key
	attr_reader :project
	attr_reader :summary
	attr_reader :status
	attr_reader :statusCategory
	attr_reader :statusCateogryId
	attr_reader :reporter
	attr_reader :fixVersion
	attr_reader :assignee
	attr_reader :created
	attr_reader :updated
	attr_reader :week
	attr_reader :year
	attr_accessor :objective
	attr_accessor :customer_facing
	attr_accessor :product

	@sub_tasks = nil
	@people = nil

	@@jql_single_issue = 'issueKey = %s'
	@@jql_sub_stories = '("Epic Link" = %s OR parent = %s) AND statusCategory = "In Progress"'
	@@jql_sub_tasks = '(parent = %s) AND statusCategory = "In Progress"'

	include ActiveModel::Model

	def self.jql_single_issue
		@@jql_single_issue
	end

	def self.load_issue( jira_client, epic_id, week, year )
		jql = URI::encode( @@jql_single_issue %  [ epic_id ]  )
		response = jira_client.get '/rest/api/2/search?jql=' + jql + JiraFilter.query_fields

		issue_list = JSON.parse( response.body )['issues']

		workItems = WorkItem.where( item_key: @item_key ).order( year: :desc, week: :desc )

		issues = issue_list.map do |issue|
			epic = JiraEpic.new( issue, week, year )
			epic.objective =  epic.getMRUObjective( workItems )
			epic.customer_facing = epic.getMRUCustomerFacing( workItems )
			epic.product = epic.getMRUProduct( workItems )
			epic.save()
		end
	end

	def initialize( issueHash, week = Date.today.cweek, year = Date.today.year )

		@item_key = issueHash['key']
		@project = issueHash['fields']['project']['name']
		@summary = issueHash['fields']['summary']
		@status = issueHash['fields']['status']['name']
		@statusCategory = issueHash['fields']['status']['statusCategory']['name']
		@statusCategoryId = issueHash['fields']['status']['statusCategory']['id']
		@fixVersion = issueHash['fields'].has_key?('fixVersions') && issueHash['fields']['fixVersions'].count >= 1 ? issueHash['fields']['fixVersions'][0]['name'] : "(empty)"
		@reporter = issueHash['fields']['reporter']['name']
		@assignee = issueHash['fields']['assignee'].nil? ? nil : issueHash['fields']['assignee']['name']
		@created = Date.strptime(issueHash['fields']['created'])
		@updated = Date.strptime(issueHash['fields']['updated'])
		@week = week
		@year = year
	end

	def save()

		newItem = false
		workItem = WorkItem.find_by( item_key: @item_key, week: week, year: year )

		# No work item found, create one
		if workItem.nil?
			newItem = true
			workItem = WorkItem.new

			# Only set people fields on first import
			workItem.num_people = @people.nil? ? 0 : @people.count
			workItem.people = @people.nil? ? "" : @people.keys.to_s
			workItem.customer_facing = @customer_facing
		end

		# Only set objective fields on first import or if empty
		if newItem || workItem.objective.nil? || workItem.objective.empty?
			workItem.objective = @objective
		end

		# Only set product on first import or if empty
		if newItem || workItem.product.nil? || workItem.product.empty?
			workItem.product = @product
		end

		workItem.item_key = @item_key
		workItem.project = @project
		workItem.summary = @summary
		workItem.status = @statusCategoryId.to_i
		workItem.reporter = @reporter
		workItem.assignee = @assignee
		workItem.fix_version = @fixVersion
		workItem.updated = @updated
		workItem.created = @created
		workItem.week = @week
		workItem.year = @year
		workItem.save()
		workItem
	end

	def load_stories( jira_client )
		jql = URI::encode( @@jql_sub_stories % [ item_key, item_key ] )
		stories = load_sub_items( jira_client, jql )
		stories.each do |story|
			sub_tasks = story.load_sub_tasks( jira_client )
		end
	end

	def load_sub_tasks( jira_client )
		jql = URI::encode( @@jql_sub_tasks % [ item_key ] )
		load_sub_items( jira_client, jql )
	end

	def load_sub_items( jira_client, jql )

		response = jira_client.get '/rest/api/2/search?jql=' + jql + JiraFilter.query_fields

		stories_search = JSON.parse( response.body )
		sub_tasks_array = stories_search['issues']

		sub_tasks = sub_tasks_array.map do |sub_task_elem|
			sub_task = JiraEpic.new( sub_task_elem )
			add_sub_task( sub_task )
			sub_task
		end
	end

	def get_sub_tasks
		@sub_tasks
	end

	def add_sub_task( issue )
		if @sub_tasks.nil?
			@sub_tasks = Array.new
		end
		@sub_tasks << issue
	end

	def load_people
		@people = Hash.new
		if !@sub_tasks.nil?
			@sub_tasks.each do |sub_task|
				if !sub_task.assignee.nil?
					@people[sub_task.assignee] = 1
				end
				sub_sub_tasks =  sub_task.get_sub_tasks
				if !sub_sub_tasks.nil?
					sub_task.get_sub_tasks.each do |sub_sub_task|
						if !sub_sub_task.assignee.nil?
							@people[sub_sub_task.assignee] = 1
						end
					end
				end
			end
		end
	end

	def people
		@people
	end

	def getMRUObjective( workItems, week = Date.today.cweek, year = Date.today.year )
		objective = nil

		workItems.each do | wi |
			if (wi.year != year || wi.week != week) && !wi.objective.nil?
				objective = wi.objective
				break
			end
		end
		return objective
	end

	def getMRUCustomerFacing( workItems, week = Date.today.cweek, year = Date.today.year )
		customer_facing = true

		workItems.each do | wi |
			if (wi.year != year || wi.week != week)
				customer_facing = wi.customer_facing
				break
			end
		end
		return customer_facing
	end

	def getMRUProduct( workItems, week = Date.today.cweek, year = Date.today.year )
		product = nil

		workItems.each do | wi |
			if (wi.year != year || wi.week != week)
				product = wi.product
				break
			end
		end
		return product
	end

end
