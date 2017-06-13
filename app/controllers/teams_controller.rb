class TeamsController < ApplicationController
	include DateManagement

	def new
		@team = Team.new
	end

	def create
		@team = Team.new(team_params)

		if @team.save
			redirect_to action: "index"
		else
			render 'new'
		end
	end

	def show
		@team = Team.find(params[:id])
		@team_updates = @team.team_updates.order( year: :desc, week: :desc )
	end

	def index
		@teams = Team.sortedCategories
	end

	def destroy
		@team = Team.find(params[:id])
		@team.destroy

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.js   { render :nothing => true }
			format.json { head :ok }
		end
	end

	def edit
		@team = Team.find(params[:id])
	end

	def update
		@team = Team.find(params[:id])

		if @team.update(team_params)
			redirect_to action: "index"
		else
			render 'edit'
		end
	end

	def copy_epics
		today, @year, @week = get_date_params(params)
		@weekNext, @yearNext = WeekMath.next_week( @week, @year )

		team_id = Team.find(params[:id])
		work_items = WorkItem.all.by_team(team_id).in_year(@year).in_week(@week)
		work_items.each do |wi|
			work_item_new = wi.dup
			work_item_new.year = @yearNext
			work_item_new.week = @weekNext
			work_item_new.save()
		end

		respond_to do |format|
			format.html { redirect_to :controller => 'work_items', :action => 'index', :week => @weekNext }
		end
	end

	def team_params
		params.require(:team).permit(:name, :description, :parent_team_id)
	end

end
