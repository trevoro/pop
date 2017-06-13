
class AnalyticsController < ApplicationController
	include DateManagement

	def project_effort_by_objective

		@project = params.has_key?(:name) ? params[:name] : nil

		# Get week specified
		today, year, week = get_date_params(params)

		limit = params.has_key?(:limit) ? params[:limit] : nil

		##########
		# Extract
		##########

		# Build objectives by week data
		# This returns a hash with
		# keys: array of length 2 ["objective", week]
		# value: int - number of people for that week
		# ex: {[\"App Directory\", 12]": 1, ...}
		team_effort_per_objective_by_week = WorkItem.all.in_year(year).in_or_before_week(week).by_project(@project)
			.group(:objective, :week).sum(:num_people)

		team_weekly_num_objectives = WorkItem.all
			.select("week, COUNT(DISTINCT objective) as objectives, SUM(num_people) as people")
			.in_year(year).in_or_before_week(week).by_project(@project).group(:week)

		##########
		# Transform
		##########

		weekly_num_objectives = Array.new()
		weekly_num_people = Array.new()

		team_weekly_num_objectives.each_with_index do |w, i|
			weekly_num_objectives.push({ "x" => i + 1, "y" => w["objectives"] })
			weekly_num_people.push({ "x" => i + 1, "y" => w["people"] })
		end

		@objectives_per_week_array = Array.new()
		record_objectives = { "key" => "Objectives", "values" => weekly_num_objectives }
		record_people = { "key" => "People", "values" => weekly_num_people }
		@objectives_per_week_array.push(record_objectives)
		@objectives_per_week_array.push(record_people)

		objectives = Hash.new

		team_effort_per_objective_by_week.each do |k,v|
			if !objectives.key?(k[0])

				# Set the value for the objective key to an array of size week with each entry
				# being an array of size 2 = [week ordinal, 0]
				objectives[k[0]] = Array.new(week){ |i| [(i+1),0] }
			end

			# Map the query results into the initialized array
			objectives[k[0]][k[1]-1][1] = v
		end

		# Structure for NVD3 stackedAreaChart display
		@people_per_objective_array = Array.new()

		@total_effort = 0

		objectives.each do |k,v|
			record = { "key" => k, "values" => v}
			objective_effort = 0
			v.each do |weekly_effort|
				objective_effort += weekly_effort[1]
			end
			@total_effort += objective_effort
			record["total"] = objective_effort
			@people_per_objective_array.push( record )
		end


		# Truncate based on limit
		limit = !limit.nil? ? limit.to_i : -1
		if limit > 0
			@people_per_objective_array.sort!{|a,b| a["total"] <=> b["total"]}.reverse!
			@people_per_objective_array = @people_per_objective_array[0..limit-1]
		end

		# Get work items for the specified year, with or without limit
		people_weeks_per_obective = WorkItem.all.in_year( year ).by_project(@project)
			.group(:objective).sum(:num_people).sort_by{|k,v| v * -1}
		if limit > 0
			people_weeks_per_obective = people_weeks_per_obective[0..limit-1]
		end

		objectives_array = Array.new()

		people_weeks_per_obective.each do |k,v|
			if v > 0
				record = { "label" => (k.nil? ? "" : k), "value" => v }
				objectives_array.push( record )
			end
		end

		nvd3_data = Array.new(1)
		nvd3_data[0] = {"key" => "Objectives", "values" => objectives_array}

		##########
		# Load
		##########

		gon.stacked1 = Array.new(1,@people_per_objective_array)

		gon.multibar1 = Array.new(1, nvd3_data)
		gon.multibar1.push( @objectives_per_week_array )

		respond_to do |format|
			format.html
		end
	end

	def objectives

		# Get week specified
		today, @year, @week = get_date_params(params)

		@weekPrev, @yearPrev = WeekMath.last_week( @week, @year )
		@weekNext, @yearNext = WeekMath.next_week( @week, @year )

		# Get work items for the week specified
		people_per_objective = WorkItem.all.in_week( @week ).in_year( @year )
			.group(:objective).sum(:num_people).sort_by{|k,v| v * -1}

		# Structure for NVD3 bar chart display
		objectives_array, total_people = WorkItem.group_work_items( :objective, @week, @year )

		objectives_array.each do |obj|
			obj["allocation"] = obj["people"].to_f / total_people.to_f
		end

		gon.multibar1 = Array.new(1, objectives_array)

		respond_to do |format|
			format.html #projects.html.erb
		end
	end

	def projects
		# Get week specified
		today, @year, @week = get_date_params(params)

		@weekPrev, @yearPrev = WeekMath.last_week( @week, @year )
		@weekNext, @yearNext = WeekMath.next_week( @week, @year )

		projects_array, @people_weeks = WorkItem.group_work_items( :project, @week, @year )

		gon.stacked1 = Array.new(1, projects_array)

		respond_to do |format|
			format.html #projects.html.erb
		end
	end

	def products
		# Get week specified
		today, @year, @week = get_date_params(params)

		@weekPrev, @yearPrev = WeekMath.last_week( @week, @year )
		@weekNext, @yearNext = WeekMath.next_week( @week, @year )

		products_array, @people_weeks = WorkItem.group_work_items( :product, @week, @year )

		gon.stacked1 = Array.new(1, products_array)

		respond_to do |format|
			format.html #projects.html.erb
		end
	end

	def projects_by_week
		# Get week specified
		today, year, week = get_date_params(params)

		projects_array = WorkItem.group_work_items_by_week( :project, week, year )

		gon.stacked1 = Array.new(1,projects_array)

		respond_to do |format|
			format.html #projects.html.erb
		end
	end

	def products_by_week
		# Get week specified
		today, year, week = get_date_params(params)

		products_array = WorkItem.group_work_items_by_week( :product, week, year )

		products_array.sort!{|a,b| b["values"][b["values"].length-1][1] <=> a["values"][a["values"].length-1][1]}

		gon.stacked1 = Array.new(1,products_array)

		respond_to do |format|
			format.html #projects.html.erb
		end
	end

	def effort_by_objective

		today, @year, week = get_date_params(params)

		@month = params.has_key?(:month) ? params[:month].to_i : 0

		# Get work items for the specified months & year
		people_weeks_per_obective = WorkItem.all.in_year( @year )
			.in_month( @month, @year )
			.group(:objective).sum(:num_people).sort_by{|k,v| v * -1}

		@objectives_array = Array.new()

		@total_effort = 0
		people_weeks_per_obective.each do |k,v|
			if v > 0
				record = { "label" => (k.nil? ? "" : k), "value" => v }
				@total_effort += v
				@objectives_array.push( record )
			end
		end

		@total_objectives = @objectives_array.size

		nvd3_data = Array.new(1)
		nvd3_data[0] = {"key" => "Objectives", "values" => @objectives_array}

		gon.multibar1 = Array.new(1, nvd3_data)

		respond_to do |format|
			format.html
		end
	end

	def effort_by_product

		today, @year, week = get_date_params(params)

		@month = params.has_key?(:month) ? params[:month].to_i : 0

		# Get work items for the specified months & year
		people_weeks_per_product = WorkItem.all.in_year( @year )
			.in_month( @month, @year )
			.group(:product).sum(:num_people).sort_by{|k,v| v * -1}

		@products_array = Array.new()

		@total_effort = 0
		people_weeks_per_product.each do |k,v|
			if v > 0
				record = { "label" => (k.nil? ? "" : k), "value" => v }
				@total_effort += v
				@products_array.push( record )
			end
		end

		@total_products = @products_array.size

		nvd3_data = Array.new(1)
		nvd3_data[0] = {"key" => "Products", "values" => @products_array}

		gon.multibar1 = Array.new(1, nvd3_data)

		respond_to do |format|
			format.html
		end
	end

	def weekly_summary
		today = Date.today
		@year = params.has_key?(:year) ? params[:year].to_i : today.year
		@week, @year = params.has_key?(:week) ? [params[:week].to_i, @year] : WeekMath.last_week( today.cweek, @year )

		team_updates = TeamUpdate.all.in_week(@week).in_year(@year)

		@title = "This Week in Product Development - week of " + Date.commercial(@year, @week).strftime( "%Y-%m-%d" )
		@full_summary = ""

		team_updates.each do |tu|
			@full_summary += "#### " + tu.team.name + "\n"
			@full_summary += tu.summary + "\n\n"
		end

		respond_to do |format|
			format.html
		end
	end
end
