class WorkItemsController < ApplicationController

	def new
		@work_item = WorkItem.new
	end

	def create
		@work_item = WorkItem.new(work_item_params)

		if @work_item.save
			redirect_to @work_item
		else
			render 'new'
		end
	end

	def show
		@work_item = WorkItem.find(params[:id])

		respond_to do |format|
			format.html #show.html.erb
			format.json {render json: @work_item}
		end
	end

	def index
		key = params.has_key?(:item_key) ? params[:item_key] : nil
		objective = params.has_key?(:objective) ? params[:objective] : nil
		product = params.has_key?(:product) ? params[:product] : nil
		today = Date.today
		@week = params.has_key?(:week) ? params[:week].to_i : 0
		@year = params.has_key?(:year) ? params[:year].to_i : today.year

		if !key.nil?
			@work_items = WorkItem.all.by_key(key).in_year(@year)
		elsif !objective.nil?
			@work_items = WorkItem.all.by_objective(objective).in_year(@year)
		else
			@weekPrev, @yearPrev = WeekMath.last_week( @week, @year )
			@weekNext, @yearNext = WeekMath.next_week( @week, @year )

			@work_items = WorkItem.all.in_week( @week ).in_year( @year ).by_product( product )
				.order("week DESC, item_key ASC")

		end

		@objectives_count = 0
		@people_weeks = 0
		@customer_facing_people_weeks = 0
		@team_list = Team.bipCollection

		if @week > 0
			objectives_hash = Hash.new
			@work_items.each do |work_item|
				if !objectives_hash.key?(work_item.objective)
					@objectives_count += 1
					objectives_hash[work_item.objective] = 1
				end
				@people_weeks += work_item.num_people.to_i
				@customer_facing_people_weeks += (work_item.customer_facing ? work_item.num_people.to_i : 0)
			end
		end

		respond_to do |format|
			format.html #index.html.erb
			format.json { respond_with_bip(@work_items) }
		end
	end

	def destroy
		@work_items = WorkItem.find(params[:id])
		@work_items.destroy

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.js   { render :nothing => true }
			format.json { head :ok }
		end
	end

	def edit
		@work_item = WorkItem.find(params[:id])
	end

	def update
		@work_item = WorkItem.find(params[:id])

		if @work_item.update_attributes(work_item_params)
			respond_to do |format|
				format.html { redirect_to(@work_item, :notice => 'Work item was successfully updated.') }
				format.json { respond_with_bip(@work_item) }
			end
		else
			render 'edit'
		end
	end

	def bulk_update_objective

		@year = params.has_key?(:year) ? params[:year].to_i : today.year
		@week = params.has_key?(:week) ? params[:week].to_i :
			(@year < today.year ? Date.new( @year, 12, 31).cweek : [1, today.cweek - 1].max)

		objective_old = params[:objective_old]
		objective_new = params[:work_items_summary][:objective]
		key = params[:key]

		data = WorkItem.all.in_year(@year).in_or_before_week(@week).by_objective(objective_old).by_key(key).update_all(:objective => objective_new)

		@work_items_summary = WorkItemsSummary.new(data, @year)

		respond_to do |format|
			format.json { respond_with_bip(@work_items_summary) }
		end
	end

	def objective
		@objective = params.has_key?(:name) ? params[:name] : nil

		# Get week specified
		today = Date.today
		@year = params.has_key?(:year) ? params[:year].to_i : today.year
		@week = params.has_key?(:week) ? params[:week].to_i :
			(@year < today.year ? Date.new( @year, 12, 31).cweek : [1, today.cweek - 1].max)

		work_items = WorkItem.all.in_year(@year).in_or_before_week(@week).by_objective(@objective)
			.group(:item_key, :project, :summary, :objective).sum(:num_people)

		@work_item_summaries = Array.new()

		work_items.each do |wi|
			work_items_summary = WorkItemsSummary.new(wi, @year)
			@work_item_summaries.push(work_items_summary)
		end



		objective_by_project_week = WorkItem.all.in_year(@year).in_or_before_week(@week).by_objective(@objective)
			.group(:project, :week).sum(:num_people)

		teams = Hash.new

		objective_by_project_week.each do |k,v|
			if !teams.key?(k[0])
				teams[k[0]] = array = Array.new(@week){ |i| [(i+1),0] }
			end
			teams[k[0]][k[1]-1][1] = v
		end

		# Structure for NVD3 bar chart display
		projects_array = Array.new()
		@total_effort = 0

		teams.each do |k,v|
			record = { "key" => k, "values" => v }
			v.each do |weekly_effort|
				@total_effort += weekly_effort[1]
			end
			projects_array.push( record )
		end

		gon.stacked1 = Array.new(1, projects_array)

		respond_to do |format|
			format.html
			format.json
		end
	end

	private

	def work_item_params
		params.require(:work_item).permit(:item_key, :team_id, :summary, :people, :num_people, :objective, :week, :year, :customer_facing, :objective_old, :product)
	end

end
