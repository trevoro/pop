class TeamUpdatesController < ApplicationController

	def new
		@team_update = TeamUpdate.new
	end

	def create
		email = current_user ? current_user.email : nil
		team_id = params[:team_update][:team_id]
		team = Team.find(team_id)
		@team_update = TeamUpdate.new(:team => team, :summary => params[:team_update][:summary],
			:week => params[:team_update][:week], :year => params[:team_update][:year], :email => email )

		if @team_update.save
			redirect_to action: "index"
		else
			render 'new'
		end
	end

	def show
		@team_update = TeamUpdate.find(params[:id])
	end

	def index

		today = Date.today

		@year = params.has_key?(:year) ? params[:year].to_i : today.year
		@week = params.has_key?(:week) ? params[:week].to_i : today.cweek

		if !params.has_key?(:week) && !params.has_key?(:year)
			@week, @year = WeekMath.last_week( @week, @year )
		end

		@weekPrev, @yearPrev = WeekMath.last_week( @week, @year )
		@weekNext, @yearNext = WeekMath.next_week( @week, @year )

		@team_updates = TeamUpdate.all.in_week(@week).in_year(@year)
			.order("week DESC")
	end

	def destroy
		@team_update = TeamUpdate.find(params[:id])
		@team_update.destroy

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.js   { render :nothing => true }
			format.json { head :ok }
		end
	end

	def edit
		@team_update = TeamUpdate.find(params[:id])

		#respond_to do |format|
			#format.html { redirect_to :action => 'index', :id => @team_update.id }
			#format.js   { render :nothing => true }
			#format.json { head :ok }
		#end
	end

	def update
		@team_update = TeamUpdate.find(params[:id])

		if @team_update.update_attributes(team_update_params)
			redirect_to @team_update
		else
			render 'edit'
		end
	end

	def team_update_params
		params.require(:team_update).permit(:title, :team_id, :summary, :week, :year, :email)
	end

end
