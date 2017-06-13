require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

	setup do
		@project = projects(:one)
	end

	test "index works" do
		get :index
		assert_response :success
		assert_not_nil assigns(:projects)
	end

	test "show works" do
		get :show, :id => @project.id
		assert_response :success
		assert_not_nil assigns(:project)
	end
end
