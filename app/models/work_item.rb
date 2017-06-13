class WorkItem < ActiveRecord::Base
	belongs_to :team
	validates_uniqueness_of :item_key, :scope => [:week, :year]

	def self.projects
		WorkItem.select(:project).in_year(Date.today.year).order(:project).distinct
	end

	scope :in_week, lambda { |week|
			if week > 0
				where('week = ?', week )
			end
		}
	scope :in_or_before_week, lambda { |week| where('week <= ?', week) }
	scope :in_year, lambda { |year| where('year = ?', year)}
	scope :by_key, lambda { |key| where('item_key = ?', key)}
	scope :by_objective, lambda { |objective| objective.nil? ? where('objective is NULL') : where('objective = ?', objective) }
	scope :by_project, lambda { |project| if !project.nil? then where( 'project = ?', project ) end }
	scope :by_product, lambda {|product| if !product.nil? then where( 'product = ?', product) end }
	scope :by_team, lambda {|team_id| if !team_id.nil? then where( 'team_id = ?', team_id) end }
	scope :in_month, lambda { |month, year| where( 'week >= ? AND week <= ?',
		WorkItem.min_week_from_month(month, year), WorkItem.max_week_from_month(month, year) ) }


	def self.min_week_from_month( month, year )
		if month < 1 || month > 12
			return 1
		end
		if month == 1
			return 1
		end
		return Date.new(year, month, 1).cweek
	end

	def self.max_week_from_month( month, year )
		if month < 1 || month > 12
			return Date.new( year, 12, -1 ).cweek
		end
		return Date.new(year, month, -1).cweek
	end

	def self.group_work_items( field, week, year )
		# Get work items for the week specified
		people_per_product = WorkItem.all.in_week( week ).in_year( year )
			.group(field).sum(:num_people).sort_by{|k,v| v * -1}

		# Structure for NVD3 bar chart display
		products_array = Array.new()

		people_weeks = 0

		people_per_product.each do |item|
			record = { field => item[0], "people" => item[1] }
			products_array.push( record )
			people_weeks += item[1]
		end

		return products_array, people_weeks
	end

	def self.group_work_items_by_week( field, week, year )

		people_per_field = WorkItem.all.in_year( year ).in_or_before_week(week)
			.group(field,:week).order(week: :desc).sum(:num_people)

		elements = Hash.new

		people_per_field.each do |k,v|
			if !elements.key?(k[0])
				elements[k[0]] = array = Array.new(week){ |i| [(i+1),0] }
			end
			elements[k[0]][k[1]-1][1] = v
		end

		# Structure for NVD3 bar chart display
		elements_array = Array.new()

		elements.each do |k,v|
			record = { "key" => k, "values" => v }
			elements_array.push( record )
		end

		return elements_array
	end

end
