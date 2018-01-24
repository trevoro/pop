class ScreenshotsController < ApplicationController

	def index
		@screenshots = Screenshot.order('created_at DESC')
	end

	def new
		@screenshot = Screenshot.new
	end

	def create
		@screenshot = Screenshot.new(screenshot_params)
		if @screenshot.save
			flash[:success] = "The screenshot was added!"
			redirect_to screenshots_path
		else
			render 'new'
		end
	end

	def destroy
		@screenshot = Screenshot.find(params[:id])
		@screenshot.destroy

		respond_to do |format|
			format.html { redirect_to :action => 'index' }
			format.js   { render :nothing => true }
			format.json { head :ok }
		end
	end

	private

	def screenshot_params
		params.require(:screenshot).permit(:image, :title)
	end

end
