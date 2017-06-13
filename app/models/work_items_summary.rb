class WorkItemsSummary

	attr_accessor :key
	attr_accessor :project
	attr_accessor :summary
	attr_accessor :objective
	attr_accessor :people_weeks
	attr_accessor :url

	include ActiveModel::Model

	def initialize( work_items, year )
		@key = work_items[0][0]
		@project = work_items[0][1]
		@summary = work_items[0][2]
		@objective = work_items[0][3]
		@people_weeks = work_items[1]
		@url = "#{ENV['JIRA_URL']}/browse/" + @key
	end

end
