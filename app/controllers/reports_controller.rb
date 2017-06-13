class ReportsController < ApplicationController

	def new
		summary = params[:summary]
		title = params[:title]
		@report = Report.new( :title => title, :summary => summary )
	end

	def create
		summary = params[:report][:summary]
		title = params[:report][:title]
		@report = Report.new(:title => title, :summary => summary)

		if @report.save
			redirect_to action: "index"
		else
			render 'new'
		end
	end

	def build
		today = Date.today
		@year = params.has_key?(:year) ? params[:year].to_i : today.year
		@week, @year = params.has_key?(:week) ? [params[:week].to_i, @year] : WeekMath.last_week( today.cweek, @year )

		team_updates = TeamUpdate.all.in_week(@week).in_year(@year)

		title = "This Week in Product Development - week of " + Date.commercial(@year, @week).strftime( "%Y-%m-%d" )
		full_summary = ""

		team_updates.each do |tu|
			full_summary += "#### " + tu.team.name + "\n"
			full_summary += tu.summary + "\n\n"
		end

		@report = Report.new(:title => title, :summary => full_summary)
		if @report.save
			redirect_to action: "index"
		else
			render 'new'
		end
	end

	def show
		@report = Report.find(params[:id])
	end

	def index
		@reports = Report.all.order(id: :desc)
	end

	def destroy
		@report = Report.find(params[:id])
		@report.destroy

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.js   { render :nothing => true }
			format.json { head :ok }
		end
	end

	def edit
		@report = Report.find(params[:id])
	end

	def update
		@report = Report.find(params[:id])

		if @report.update_attributes(report_params)
			redirect_to @report
		else
			render 'edit'
		end
	end

	def report_params
		params.require(:report).permit(:title, :summary)
	end

end
