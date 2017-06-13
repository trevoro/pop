class ProjectsController < ApplicationController

	def new
		@project = Project.new
		@teams = Team.selector
	end

	def create
		@project = Project.new(project_params)

		if @project.save
			redirect_to @project
		else
			render 'new'
		end
	end

	def show
		@project = Project.find(params[:id])
	end

	def index
		@projects = Project.all
	end

	def status_index
		@projects_future = Project.all.future
		@projects_completed = Project.all.completed
		@projects = Project.all.current
	end

	def destroy
		@project = Project.find(params[:id])
		@project.destroy

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.js   { render :nothing => true }
			format.json { head :ok }
		end
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])

		if @project.update(project_params)
			redirect_to @project
		else
			render 'edit'
		end
	end

	def project_params
		params.require(:project).permit(:title, :description)
	end
end
